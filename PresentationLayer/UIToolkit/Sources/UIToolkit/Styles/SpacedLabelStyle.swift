//
//  SpacedLabelStyle.swift
//  UIToolkit
//
//  Created by Miroslav Tourek on 13.04.2026.
//

import SwiftUI

/// A label style that allows configuring the spacing between the icon and title.
public struct SpacedLabelStyle: LabelStyle {
    private let spacing: CGFloat
    
    public init(spacing: CGFloat) {
        self.spacing = spacing
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        HStack(alignment: .top, spacing: spacing) {
            configuration.icon
            configuration.title
        }
    }
}
