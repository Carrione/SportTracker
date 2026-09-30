//
//  ProfileCoordinatorView.swift
//  Profile
//
//  Created by Miroslav Tourek on 13.04.2026.
//

import SwiftUI

public struct ProfileCoordinatorView: View {
    
    // MARK: - Properties
    
    private var coordinator: ProfileCoordinator
    
    // MARK: - init
    
    public init(coordinator: ProfileCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: - Body
    
    public var body: some View {
        if coordinator.isSignedIn {
            ProfileScreen(coordinator: coordinator)
        } else {
            SignInScreen(coordinator: coordinator)
        }
    }
}
