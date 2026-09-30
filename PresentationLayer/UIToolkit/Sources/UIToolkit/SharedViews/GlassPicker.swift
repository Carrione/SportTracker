//
//  GlassPicker.swift
//  UIToolkit
//
//  Created by Miroslav Tourek on 13.04.2026.
//

import SwiftUI

public struct GlassPicker<Tab: CaseIterable & Hashable & Sendable>: View
where Tab.AllCases: RandomAccessCollection {
    
    // MARK: - Properties
    
    private let selected: Tab
    private let onSelect: (Tab) -> Void
    private let label: (Tab) -> String
    private let options: [Tab]
    
    @Namespace private var animation
    
    private let spacing: CGFloat = 8
    private let verticalPadding: CGFloat = 8
    private let horizontalPadding: CGFloat = 16
    
    // MARK: - init
    
    public init(
        selected: Tab,
        onSelect: @escaping (Tab) -> Void,
        label: @escaping (Tab) -> String,
        options: [Tab]? = nil
    ) {
        self.selected = selected
        self.onSelect = onSelect
        self.label = label
        self.options = options ?? Array(Tab.allCases)
    }
    
    // MARK: - Body
    
    public var body: some View {
        GlassEffectContainer {
            HStack(spacing: spacing) {
                ForEach(options, id: \.self) { tab in
                    Button {
                        if selected != tab {
                            onSelect(tab)
                        }
                    } label: {
                        Text(LocalizedStringKey(label(tab)))
                            .padding(.horizontal, horizontalPadding)
                            .padding(.vertical, verticalPadding)
                            .contentShape(.capsule)
                    }
                    .buttonStyle(.plain)
                    .glassEffect(
                        selected == tab ? .regular.tint(.accentColor) : .regular,
                        in: .capsule
                    )
                    .glassEffectID(tab, in: animation)
                }
            }
        }
        .animation(.default, value: selected)
    }
}
