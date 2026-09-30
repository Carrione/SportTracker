//
//  AddActivityViewModel.swift
//  AddActivity
//
//  Created by Miroslav Tourek on 15.04.2026.
//

import DependencyInjection
import Observation
import SharedDomain

// MARK: - Delegate protocol

@MainActor
protocol AddActivityViewModelDelegate: AnyObject {
    func activitySaved()
}

// MARK: - State

extension AddActivityViewModel {
    struct State {
        static let defaultDuration: Duration = .seconds(1800) // 30 min
        static let defaultStorage: StorageType = .local
        
        var name: String = ""
        var location: String = ""
        var duration: Duration = defaultDuration
        var storageType: StorageType = defaultStorage
        var isSaving: Bool = false
        var errorMessage: String?
    }
}

@Observable
@MainActor
final class AddActivityViewModel {
    private(set) var state: State = State()
    
    // MARK: - Properties
    
    weak var delegate: (any AddActivityViewModelDelegate)?
    
    @ObservationIgnored @Injected(\.saveActivityUseCase) private var saveUseCase
    @ObservationIgnored @Injected(\.logErrorUseCase) private var logErrorUseCase
    @ObservationIgnored @Injected(\.logEventUseCase) private var logEventUseCase
    @ObservationIgnored @Injected(\.authService) private var authService
    
    var storageTypes: [StorageType] {
        authService.isSignedIn ? StorageType.allCases : [.local]
    }
    
    // MARK: - Intent
    
    enum AddActivityIntent {
        case setName(String)
        case setLocation(String)
        case setDuration(Duration)
        case setStorageType(StorageType)
        case save
        case clearError
    }
    
    func onIntent(_ intent: AddActivityIntent) {
        switch intent {
        case let .setName(value): state.name = value
        case let .setLocation(value): state.location = value
        case let .setDuration(value): state.duration = value
        case let .setStorageType(value): state.storageType = value
        case .save: Task { await save() }
        case .clearError: state.errorMessage = nil
        }
    }
    
    // MARK: - Private functions
    
    private func save() async {
        state.isSaving = true
        state.errorMessage = nil
        defer { state.isSaving = false }
        
        do {
            try await saveUseCase.execute(
                name: state.name,
                location: state.location,
                duration: state.duration,
                storageType: state.storageType
            )
            logEventUseCase.execute(event: .activityAdded(storageType: state.storageType))
            resetForm()
            delegate?.activitySaved()
        } catch {
            logErrorUseCase.execute(error: error)
            state.errorMessage = error.localizedDescription
        }
    }
    
    private func resetForm() {
        state.name = ""
        state.location = ""
        state.duration = State.defaultDuration
        state.storageType = State.defaultStorage
    }
}
