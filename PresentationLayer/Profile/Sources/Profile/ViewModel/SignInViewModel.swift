//
//  SignInViewModel.swift
//  Profile
//
//  Created by Miroslav Tourek on 13.04.2026.
//

import DependencyInjection
import Observation

// MARK: - State

extension SignInViewModel {
    struct State {
        var isLoading: Bool = false
        var errorMessage: String? = nil
    }
}

@Observable
@MainActor
final class SignInViewModel {
    private(set) var state: State = State()
    
    // MARK: - Properties
    
    @ObservationIgnored @Injected(\.authService) private var authService
    @ObservationIgnored @Injected(\.logErrorUseCase) private var logErrorUseCase
    @ObservationIgnored @Injected(\.logEventUseCase) private var logEventUseCase
    
    // MARK: - Intent
    
    enum SignInIntent {
        case signInAnonymously
        case signInWithGoogle
        case clearError
    }
    
    func handle(_ intent: SignInIntent) {
        switch intent {
        case .signInAnonymously: Task { await signInAnonymously() }
        case .signInWithGoogle: Task { await signInWithGoogle() }
        case .clearError: state.errorMessage = nil
        }
    }
    
    // MARK: - Private functions
    
    private func signInAnonymously() async {
        state.isLoading = true
        defer { state.isLoading = false }
        do {
            try await authService.signInAnonymously()
            logEventUseCase.execute(event: .userSignedIn(method: .anonymous))
        } catch {
            logErrorUseCase.execute(error: error)
            state.errorMessage = error.localizedDescription
        }
    }
    
    private func signInWithGoogle() async {
        state.isLoading = true
        defer { state.isLoading = false }
        do {
            try await authService.signInWithGoogle()
            logEventUseCase.execute(event: .userSignedIn(method: .google))
        } catch {
            logErrorUseCase.execute(error: error)
            state.errorMessage = error.localizedDescription
        }
    }
}
