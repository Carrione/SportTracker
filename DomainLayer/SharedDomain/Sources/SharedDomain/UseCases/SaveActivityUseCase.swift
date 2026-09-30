//
//  SaveActivityUseCase.swift
//  SharedDomain
//
//  Created by Miroslav Tourek on 13.04.2026.
//

public protocol SaveActivityUseCase: Sendable {
    func execute(
        name: String,
        location: String,
        duration: Duration,
        storageType: StorageType
    ) async throws
}

public struct SaveActivityUseCaseImpl: SaveActivityUseCase {
    private let repository: any SportActivityRepository
    
    public init(repository: some SportActivityRepository) {
        self.repository = repository
    }
    
    public func execute(
        name: String,
        location: String,
        duration: Duration,
        storageType: StorageType
    ) async throws {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedLocation = location.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedName.isEmpty else { throw ActivityValidationError.emptyName }
        guard !trimmedLocation.isEmpty else { throw ActivityValidationError.emptyLocation }
        guard duration > .zero else { throw ActivityValidationError.zeroDuration }
        
        let activity = SportActivity(
            name: trimmedName,
            location: trimmedLocation,
            duration: duration,
            storageType: storageType
        )
        try await repository.save(activity)
    }
}
