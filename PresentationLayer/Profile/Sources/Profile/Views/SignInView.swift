//
//  SignInView.swift
//  Profile
//
//  Created by Miroslav Tourek on 13.04.2026.
//

import SwiftUI
import UIToolkit

struct SignInView: View {
    
    // MARK: - Properties
    
    private var viewModel: SignInViewModel
    
    private let spacing: CGFloat = 46
    private let headerSpacing: CGFloat = 16
    private let imageFontSize: CGFloat = 80
    private let buttonLabelVerticalPadding: CGFloat = 12
    private let buttonHorizontalPadding: CGFloat = 32
    
    // MARK: - init
    
    init(viewModel: SignInViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(spacing: spacing) {
                signInHeader
                
                Button {
                    viewModel.handle(.signInWithGoogle)
                } label: {
                    HStack {
                        Image(systemName: "globe")
                        Text("Sign_in_with_Google")
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, buttonLabelVerticalPadding)
                }
                .glassEffect(.regular.interactive(), in: .capsule)
                .padding(.horizontal, buttonHorizontalPadding)

                Button("Sign_in_anonymously") {
                    viewModel.handle(.signInAnonymously)
                }
                .padding(.horizontal, buttonHorizontalPadding)
            }
        }
        .scrollIndicators(.hidden)
        .defaultScrollAnchor(.center)
        .overlay {
            if viewModel.state.isLoading { LoadingView() }
        }
        .errorAlert(message: Binding(
            get: { viewModel.state.errorMessage },
            set: { _ in viewModel.handle(.clearError) }
        ))
    }
    
    // MARK: - Subviews
    
    private var signInHeader: some View {
        VStack(spacing: headerSpacing) {
            Image(systemName: "figure.run.circle.fill")
                .font(.system(size: imageFontSize))
                .foregroundStyle(.tint)
            
            Text("SportTracker")
                .font(.largeTitle.bold())
            
            Text("Sign_in_header_subtitle")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }
}
