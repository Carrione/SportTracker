//
//  SignInScreen.swift
//  Profile
//
//  Created by Miroslav Tourek on 13.04.2026.
//

import SwiftUI

struct SignInScreen: View {

    // MARK: - Properties

    @State private var viewModel: SignInViewModel

    // MARK: - init

    init(coordinator: ProfileCoordinator) {
        _viewModel = State(wrappedValue: coordinator.makeSignInViewModel())
    }

    // MARK: - Body

    var body: some View {
        SignInView(viewModel: viewModel)
    }
}
