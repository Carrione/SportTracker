//
//  ProfileCoordinator.swift
//  Profile
//
//  Created by Miroslav Tourek on 13.04.2026.
//

import Observation
import DependencyInjection

@Observable
@MainActor
public final class ProfileCoordinator {
    
    // MARK: - Properties

    @ObservationIgnored @Injected(\.authService) private var authService

    var isSignedIn: Bool { authService.isSignedIn }

    // MARK: - init

    public init() {}

    // MARK: - Factories

    func makeSignInViewModel() -> SignInViewModel {
        SignInViewModel()
    }

    func makeProfileViewModel() -> ProfileViewModel {
        ProfileViewModel()
    }
}
