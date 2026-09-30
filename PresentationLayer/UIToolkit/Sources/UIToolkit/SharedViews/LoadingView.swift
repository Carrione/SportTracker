//
//  LoadingView.swift
//  UIToolkit
//
//  Created by Miroslav Tourek on 13.04.2026.
//

import SwiftUI

public struct LoadingView: View {
    public init() {}
    
    public var body: some View {
        ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
