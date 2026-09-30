//
//  SignOutUseCase.swift
//  SharedDomain
//
//  Created by Miroslav Tourek on 13.04.2026.
//

public protocol SignOutUseCase: Sendable {
    func execute() async throws
}

public struct SignOutUseCaseImpl: SignOutUseCase {
    private let authService: any AuthServiceProtocol
    private let repository: any SportActivityRepository

    public init(authService: some AuthServiceProtocol, repository: some SportActivityRepository) {
        self.authService = authService
        self.repository = repository
    }
    
    public func execute() async throws {
        if authService.isAnonymous {
            try await repository.deleteAllLocalActivities()
        }
        try authService.signOut()
    }
}
