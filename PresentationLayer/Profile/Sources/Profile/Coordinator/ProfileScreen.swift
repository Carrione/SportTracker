//
//  ProfileScreen.swift
//  Profile
//
//  Created by Miroslav Tourek on 13.04.2026.
//

import SwiftUI

struct ProfileScreen: View {

    // MARK: - Properties

    @State private var viewModel: ProfileViewModel

    // MARK: - init

    init(coordinator: ProfileCoordinator) {
        _viewModel = State(wrappedValue: coordinator.makeProfileViewModel())
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ProfileView(viewModel: viewModel)
        }
    }
}
