//
//  WheelColumn.swift
//  AddActivity
//
//  Created by Miroslav Tourek on 17.04.2026.
//

import SwiftUI

struct WheelColumn: View {
    
    // MARK: - Properties
    
    private let label: String
    private let range: Range<Int>
    @Binding private var selection: Int
    
    // MARK: - init
    
    init(label: String, range: Range<Int>, selection: Binding<Int>) {
        self.label = label
        self.range = range
        _selection = selection
    }
    
    // MARK: - Body
    
    var body: some View {
        Picker(label, selection: $selection) {
            ForEach(range, id: \.self) { Text("\($0)\(label)") }
        }
        .pickerStyle(.wheel)
        .frame(maxWidth: .infinity)
    }
}
