//
//  DurationPicker.swift
//  AddActivity
//
//  Created by Miroslav Tourek on 15.04.2026.
//

import SwiftUI

struct DurationPicker: View {
    
    // MARK: - State
    
    @State private var hours: Int
    @State private var minutes: Int
    @State private var seconds: Int
    
    // MARK: - Properties
    
    @Binding private var duration: Duration
    private var onInteraction: (() -> Void)? = nil
    
    // MARK: - init
    
    init(duration: Binding<Duration>, onInteraction: (() -> Void)? = nil) {
        _duration = duration
        self.onInteraction = onInteraction
        let (totalSeconds, _) = duration.wrappedValue.components
        let total = Int(totalSeconds)
        _hours   = State(initialValue: total / 3600)
        _minutes = State(initialValue: (total % 3600) / 60)
        _seconds = State(initialValue: total % 60)
    }
    
    // MARK: - Body
    
    var body: some View {
        HStack {
            WheelColumn(label: "h", range: 0..<24, selection: $hours)
            WheelColumn(label: "m", range: 0..<60, selection: $minutes)
            WheelColumn(label: "s", range: 0..<60, selection: $seconds)
        }
        .simultaneousGesture(
            DragGesture(minimumDistance: 0).onChanged { _ in onInteraction?() }
        )
        .onChange(of: hours) { _, _ in updateDuration() }
        .onChange(of: minutes) { _, _ in updateDuration() }
        .onChange(of: seconds) { _, _ in updateDuration() }
    }
    
    // MARK: - Private functions
    
    private func updateDuration() {
        let total = hours * 3600 + minutes * 60 + seconds
        duration = .seconds(total)
    }
}
