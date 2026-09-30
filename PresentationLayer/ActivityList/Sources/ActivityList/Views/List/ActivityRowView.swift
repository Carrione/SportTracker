//
//  ActivityRowView.swift
//  ActivityList
//
//  Created by Miroslav Tourek on 13.04.2026.
//

import SharedDomain
import SwiftUI
import UIToolkit

struct ActivityRowView: View {
    
    // MARK: - Properties
    
    private let activity: SportActivity
    
    private let padding: CGFloat = 4
    private let verticalSpacing: CGFloat = 8
    private let horizontalSpacing: CGFloat = 16
    private let labelStyleSpacing: CGFloat = 4
    
    // MARK: - init
    
    init(activity: SportActivity) {
        self.activity = activity
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: verticalSpacing) {
            HStack(alignment: .top) {
                Text(activity.name)
                    .font(.headline)
                    .foregroundStyle(.foreground)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                StorageTypeBadge(storageType: activity.storageType)
            }
            
            HStack(alignment: .top, spacing: horizontalSpacing) {
                Label(activity.location, systemImage: "mappin")
                
                Label(activity.duration.formatted, systemImage: "clock")
            }
            .labelStyle(SpacedLabelStyle(spacing: labelStyleSpacing))
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
        .padding(padding)
        .contentShape(.rect)
    }
}
