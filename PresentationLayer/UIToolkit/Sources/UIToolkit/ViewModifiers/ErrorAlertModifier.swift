//
//  ErrorAlertModifier.swift
//  UIToolkit
//
//  Created by Miroslav Tourek on 13.04.2026.
//

import SwiftUI

public struct ErrorAlertModifier: ViewModifier {
    @Binding private var errorMessage: String?
    
    public init(errorMessage: Binding<String?>) {
        _errorMessage = errorMessage
    }
    
    public func body(content: Content) -> some View {
        content
            .alert("Error_title", isPresented: Binding(
                get: { errorMessage != nil },
                set: { if !$0 { errorMessage = nil } }
            )) {
                Button("OK") { errorMessage = nil }
            } message: {
                if let message = errorMessage {
                    Text(message)
                }
            }
    }
}
