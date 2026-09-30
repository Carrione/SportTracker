//
//  AuthServiceProtocol.swift
//  SharedDomain
//
//  Created by Miroslav Tourek on 13.04.2026.
//

@MainActor
public protocol AuthServiceProtocol: AnyObject, Sendable {
    var isSignedIn: Bool { get }
    var isAnonymous: Bool { get }
    var displayName: String? { get }
    var uid: String? { get }
    
    func signInAnonymously() async throws
    func signInWithGoogle() async throws
    func linkWithGoogle() async throws
    func signOut() throws
}
