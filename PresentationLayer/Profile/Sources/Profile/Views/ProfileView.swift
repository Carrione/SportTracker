//
//  ProfileView.swift
//  Profile
//
//  Created by Miroslav Tourek on 13.04.2026.
//

import SwiftUI
import UIToolkit

struct ProfileView: View {
    
    // MARK: - Properties
    
    private var viewModel: ProfileViewModel
    
    // MARK: - init
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    
    var body: some View {
        List {
            accountSection
            signOutSection
        }
        .navigationTitle("Profile")
        .overlay {
            if viewModel.state.isLoading { LoadingView() }
        }
        .errorAlert(message: Binding(
            get: { viewModel.state.errorMessage },
            set: { _ in viewModel.onIntent(.clearError) }
        ))
    }
    
    // MARK: - Subviews
    
    private var accountSection: some View {
        Section("Account") {
            LabeledContent("User", value: viewModel.displayName ?? "Anonymous")
            
            if viewModel.isAnonymous {
                Button {
                    viewModel.onIntent(.linkWithGoogle)
                } label: {
                    Label("Link_google_ccount", systemImage: "link")
                }
            }
        }
    }
    
    private var signOutSection: some View {
        Section {
            Button(role: .destructive) {
                viewModel.onIntent(.signOut)
            } label: {
                Label("Sign_out", systemImage: "rectangle.portrait.and.arrow.right")
            }
        }
    }
}
