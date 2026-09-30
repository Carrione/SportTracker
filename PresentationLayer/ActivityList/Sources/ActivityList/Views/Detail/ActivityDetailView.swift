//
//  ActivityDetailView.swift
//  ActivityList
//
//  Created by Miroslav Tourek on 14.04.2026.
//

import SwiftUI
import UIToolkit

struct ActivityDetailView: View {
    
    // MARK: - Properties
    
    private let viewModel: ActivityDetailViewModel
    
    // MARK: - init
    
    init(viewModel: ActivityDetailViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    
    var body: some View {
        let activity = viewModel.state.activity
        List {
            Section {
                labeledContent("Title", value: activity.name)
                labeledContent("Location", value: activity.location)
                labeledContent("Duration", value: activity.duration.formatted)
                
                HStack(alignment: .top) {
                    Text("Stored")
                        .font(.headline)
                        .foregroundStyle(.foreground)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    StorageTypeBadge(storageType: activity.storageType)
                }
            }
            
            Section("Date") {
                labeledContent("Created", value: activity.createdAt.formatted(date: .abbreviated, time: .shortened))
            }
        }
        .navigationTitle(activity.name)
        .navigationBarTitleDisplayMode(.large)
    }
    
    // MARK: - Subviews
    
    private func labeledContent(_ titleKey: LocalizedStringKey, value: String) -> some View {
        LabeledContent {
            Text(value)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        } label: {
            Text(titleKey)
                .font(.headline)
        }
        .foregroundStyle(.foreground)
        
    }
}
