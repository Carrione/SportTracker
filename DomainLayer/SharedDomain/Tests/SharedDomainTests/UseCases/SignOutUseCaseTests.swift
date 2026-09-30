//
//  SignOutUseCaseTests.swift
//  SharedDomain
//
//  Created by Miroslav Tourek on 13.04.2026.
//

@testable import SharedDomain
import Testing

@Suite("SignOutUseCase")
struct SignOutUseCaseTests {

    private static func makeSUT(isAnonymous: Bool) -> (
        sut: SignOutUseCaseImpl,
        auth: MockAuthService,
        repository: MockSportActivityRepository
    ) {
        let auth = MockAuthService()
        auth.isAnonymous = isAnonymous
        let repository = MockSportActivityRepository()
        return (SignOutUseCaseImpl(authService: auth, repository: repository), auth, repository)
    }

    @Test("purges local activities when the signed-out account is anonymous")
    func execute_anonymous_purgesLocalActivities() async throws {
        let (sut, auth, repository) = Self.makeSUT(isAnonymous: true)

        try await sut.execute()

        #expect(repository.deleteAllLocalCallCount == 1)
        #expect(auth.signOutCallCount == 1)
    }

    @Test("keeps local activities when the account can be signed into again")
    func execute_linkedAccount_keepsLocalActivities() async throws {
        let (sut, auth, repository) = Self.makeSUT(isAnonymous: false)

        try await sut.execute()

        #expect(repository.deleteAllLocalCallCount == 0)
        #expect(auth.signOutCallCount == 1)
    }

    @Test("does not sign out when purging fails")
    func execute_purgeFails_doesNotSignOut() async throws {
        let (sut, auth, repository) = Self.makeSUT(isAnonymous: true)
        repository.shouldThrow = ActivityRepositoryError.notFound

        await #expect(throws: ActivityRepositoryError.self) {
            try await sut.execute()
        }
        #expect(auth.signOutCallCount == 0)
    }
}
