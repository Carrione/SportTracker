//
//  DeleteActivityUseCase.swift
//  SharedDomain
//
//  Created by Miroslav Tourek on 13.04.2026.
//

public protocol DeleteActivityUseCase: Sendable {
    func execute(_ activity: SportActivity) async throws
}

public struct DeleteActivityUseCaseImpl: DeleteActivityUseCase {
    private let repository: any SportActivityRepository
    
    public init(repository: some SportActivityRepository) {
        self.repository = repository
    }
    
    public func execute(_ activity: SportActivity) async throws {
        try await repository.delete(activity)
    }
}
