//
//  LoadingView.swift
//  UIToolkit
//
//  Created by Miroslav Tourek on 13.04.2026.
//

import SharedDomain
import SwiftUI

public struct StorageTypeBadge: View {
    
    // MARK: - Properties
    
    private let storageType: StorageType
    
    private let horizontalPadding: CGFloat = 8
    private let verticalPadding: CGFloat = 4
    
    private var tintColor: Color {
        switch storageType {
        case .local:  .blue
        case .remote: .purple
        }
    }
    
    // MARK: - init
    
    public init(storageType: StorageType) {
        self.storageType = storageType
    }
    
    // MARK: - Body
    
    public var body: some View {
        Text(LocalizedStringKey(storageType.displayName))
            .font(.caption2.weight(.semibold))
            .foregroundStyle(.white)
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .glassEffect(.regular.tint(tintColor), in: .capsule)
    }
}
