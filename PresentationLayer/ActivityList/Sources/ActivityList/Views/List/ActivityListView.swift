//
//  ActivityListView.swift
//  ActivityList
//
//  Created by Miroslav Tourek on 13.04.2026.
//

import SwiftUI
import UIToolkit

struct ActivityListView: View {
    
    // MARK: - Properties
    
    private var viewModel: ActivityListViewModel
    
    // MARK: - init
    
    init(viewModel: ActivityListViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    
    var body: some View {
        Group {
            if viewModel.state.isLoading && viewModel.state.activities.isEmpty {
                LoadingView()
            } else if viewModel.state.activities.isEmpty {
                ContentUnavailableView(
                    "No_activities",
                    systemImage: "figure.run",
                    description: Text("Add_first_activity")
                )
            } else {
                List {
                    ForEach(viewModel.state.activities) { activity in
                        Button {
                            viewModel.onIntent(.showDetail(activity))
                        } label: {
                            ActivityRowView(activity: activity)
                        }
                        .buttonStyle(.plain)
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            let activity = viewModel.state.activities[index]
                            viewModel.onIntent(.delete(activity))
                        }
                    }
                }
                .animation(.default, value: viewModel.state.activities)
            }
        }
        .animation(.default, value: viewModel.state.activities)
        .navigationTitle("Activities")
        // GlassPicker is placed via safeAreaInset rather than .toolbar(.bottomBar)
        // to avoid "Adding UIKitToolbar as a subview of UIHostingController.view" warnings
        // on iOS 26.
        .safeAreaInset(edge: .bottom) {
            GlassPicker(
                selected: viewModel.state.selectedFilter,
                onSelect: { viewModel.onIntent(.selectFilter($0)) },
                label: \.rawValue
            )
            .padding(.bottom)
        }
        .onAppear {
            viewModel.onIntent(.onAppear)
        }
        // Explicit binding is required because `viewModel` is not @Bindable,
        // and to route dismissal through the Intent pattern instead of
        // directly mutating state from the view.
        .errorAlert(message: Binding(
            get: { viewModel.state.errorMessage },
            set: { _ in viewModel.onIntent(.clearError) }
        ))
    }
}
