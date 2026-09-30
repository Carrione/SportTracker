//
//  AddActivityView.swift
//  AddActivity
//
//  Created by Miroslav Tourek on 15.04.2026.
//

import SwiftUI
import UIToolkit

struct AddActivityView: View {
    
    // MARK: - State
    
    private enum Field { case name, location }
    @FocusState private var focusedField: Field?
    
    // MARK: - Properties
    
    private var viewModel: AddActivityViewModel
    
    private let verticalPadding: CGFloat = 8
    
    // MARK: - init
    
    init(viewModel: AddActivityViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    
    var body: some View {
        Form {
            activitySection
            durationSection
            storageSection
        }
        .scrollDismissesKeyboard(.interactively)
        .simultaneousGesture(TapGesture().onEnded { focusedField = nil })
        .navigationTitle("Add_activity")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                if viewModel.state.isSaving {
                    ProgressView()
                } else {
                    Button("Save") {
                        viewModel.onIntent(.save)
                    }
                    .disabled(viewModel.state.name.isEmpty || viewModel.state.location.isEmpty)
                }
            }
        }
        .errorAlert(message: Binding(
            get: { viewModel.state.errorMessage },
            set: { if $0 == nil { viewModel.onIntent(.clearError) } }
        ))
    }
    
    // MARK: - Subviews
    
    private var activitySection: some View {
        Section("Activity") {
            TextField("Title", text: Binding(
                get: { viewModel.state.name },
                set: { viewModel.onIntent(.setName($0)) }
            ))
            .focused($focusedField, equals: .name)
            
            TextField("Location", text: Binding(
                get: { viewModel.state.location },
                set: { viewModel.onIntent(.setLocation($0)) }
            ))
            .focused($focusedField, equals: .location)
        }
    }
    
    private var durationSection: some View {
        Section("Duration") {
            DurationPicker(
                duration: Binding(
                    get: { viewModel.state.duration },
                    set: { viewModel.onIntent(.setDuration($0)) }
                ),
                onInteraction: { focusedField = nil }
            )
        }
    }
    
    private var storageSection: some View {
        Section("Storage") {
            GlassPicker(
                selected: viewModel.state.storageType,
                onSelect: {
                    focusedField = nil
                    viewModel.onIntent(.setStorageType($0))
                },
                label: { $0.displayName },
                options: viewModel.storageTypes
            )
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
            .padding(.vertical, verticalPadding)
        }
    }
}
