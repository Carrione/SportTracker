//
//  FirebaseAuthService.swift
//  FirebaseToolkit
//
//  Created by Miroslav Tourek on 13.04.2026.
//

import FirebaseAuth
import GoogleSignIn
import SharedDomain
import UIKit

// MARK: - AuthError

private enum AuthError: LocalizedError {
    case noPresentationContext
    case missingIDToken
    case notSignedIn

    var errorDescription: String? {
        switch self {
        case .noPresentationContext: "Sign-in could not be presented. Please try again."
        case .missingIDToken: "Google did not return a valid identity token."
        case .notSignedIn: "There is no signed-in account to link."
        }
    }
}

@Observable
@MainActor
public final class FirebaseAuthService: AuthServiceProtocol {
    public private(set) var isSignedIn: Bool = false
    public private(set) var isAnonymous: Bool = false
    public private(set) var displayName: String? = nil
    public private(set) var uid: String? = nil

    private let presentingViewController: @MainActor () -> UIViewController?

    nonisolated(unsafe) private var authStateListener: AuthStateDidChangeListenerHandle?

    public init(presentingViewController: @escaping @MainActor () -> UIViewController?) {
        self.presentingViewController = presentingViewController
        
        updateState(from: Auth.auth().currentUser)
        
        authStateListener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            Task { @MainActor [weak self] in
                self?.updateState(from: user)
            }
        }
    }
    
    deinit {
        if let handle = authStateListener {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    public func signInAnonymously() async throws {
        try await Auth.auth().signInAnonymously()
    }
    
    public func signInWithGoogle() async throws {
        try await Auth.auth().signIn(with: googleCredential())
    }

    public func linkWithGoogle() async throws {
        guard let user = Auth.auth().currentUser else {
            throw AuthError.notSignedIn
        }
        try await user.link(with: googleCredential())
        
        try await user.reload()
        updateState(from: Auth.auth().currentUser)
    }

    public func signOut() throws {
        try Auth.auth().signOut()
    }

    // MARK: - Private

    private func updateState(from user: User?) {
        isSignedIn = user != nil
        isAnonymous = user?.isAnonymous ?? false
        uid = user?.uid
        displayName = user?.resolvedDisplayName
    }

    /// Runs the Google Sign-In flow and converts its result into a Firebase credential.
    private func googleCredential() async throws -> AuthCredential {
        guard let presenting = presentingViewController() else {
            throw AuthError.noPresentationContext
        }
        
        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: presenting)
       
        guard let idToken = result.user.idToken else {
            throw AuthError.missingIDToken
        }
        
        return GoogleAuthProvider.credential(
            withIDToken: idToken.tokenString,
            accessToken: result.user.accessToken.tokenString
        )
    }
}

// MARK: - User extension

private extension User {
    var resolvedDisplayName: String? {
        displayName ?? providerData.lazy.compactMap(\.displayName).first
    }
}
