//
//  MockAuthService.swift
//  SharedDomain
//
//  Created by Miroslav Tourek on 13.04.2026.
//

import SharedDomain

@MainActor
final class MockAuthService: AuthServiceProtocol {
    var isSignedIn: Bool = true
    var isAnonymous: Bool = false
    var displayName: String? = nil
    var uid: String? = "test-uid"

    private(set) var signOutCallCount = 0
    var shouldThrow: Error? = nil

    func signInAnonymously() async throws {}
    func signInWithGoogle() async throws {}
    func linkWithGoogle() async throws {}

    func signOut() throws {
        if let error = shouldThrow { throw error }
        signOutCallCount += 1
        isSignedIn = false
    }
}
