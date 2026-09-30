//
//  ProfileViewModel.swift
//  Profile
//
//  Created by Miroslav Tourek on 13.04.2026.
//

import DependencyInjection
import Observation

// MARK: - State

extension ProfileViewModel {
    /// Mutable state owned by the ViewModel — UI-driven values that change in response to user actions.
    ///
    /// Data derived from external services (e.g. `displayName`, `isAnonymous`) is intentionally
    /// excluded from `State` and exposed as computed properties directly on the ViewModel.
    /// Because `FirebaseAuthService` is `@Observable`, SwiftUI tracks those properties transitively
    /// during view body evaluation, so no manual synchronisation is needed.
    struct State {
        var isLoading: Bool = false
        var errorMessage: String? = nil
    }
}

@Observable
@MainActor
final class ProfileViewModel {
    private(set) var state: State = State()
    var displayName: String? { authService.displayName }
    var isAnonymous: Bool { authService.isAnonymous }
    
    // MARK: - Properties
    
    @ObservationIgnored @Injected(\.authService) private var authService
    @ObservationIgnored @Injected(\.signOutUseCase) private var signOutUseCase
    @ObservationIgnored @Injected(\.logErrorUseCase) private var logErrorUseCase
    @ObservationIgnored @Injected(\.logEventUseCase) private var logEventUseCase
    
    // MARK: - Intent
    
    enum ProfileIntent {
        case signOut
        case linkWithGoogle
        case clearError
    }
    
    func onIntent(_ intent: ProfileIntent) {
        switch intent {
        case .signOut: Task { await signOut() }
        case .linkWithGoogle: Task { await linkWithGoogle() }
        case .clearError: state.errorMessage = nil
        }
    }
    
    // MARK: - Private functions
    
    private func signOut() async {
        do {
            try await signOutUseCase.execute()
            logEventUseCase.execute(event: .userSignedOut)
        } catch {
            logErrorUseCase.execute(error: error)
            state.errorMessage = error.localizedDescription
        }
    }
    
    private func linkWithGoogle() async {
        state.isLoading = true
        defer { state.isLoading = false }
        do {
            try await authService.linkWithGoogle()
            logEventUseCase.execute(event: .userLinkedWithGoogle)
        } catch {
            logErrorUseCase.execute(error: error)
            state.errorMessage = error.localizedDescription
        }
    }
}
