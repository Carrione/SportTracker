//
//  View+extensions.swift
//  UIToolkit
//
//  Created by Miroslav Tourek on 17.04.2026.
//

import SwiftUI

public extension View {
    func errorAlert(message: Binding<String?>) -> some View {
        modifier(ErrorAlertModifier(errorMessage: message))
    }
}
