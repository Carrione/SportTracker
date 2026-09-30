//
//  ActivityListCoordinatorView.swift
//  ActivityList
//
//  Created by Miroslav Tourek on 13.04.2026.
//

import SharedDomain
import SwiftUI

public struct ActivityListCoordinatorView: View {
    
    // MARK: - Properties
    
    @Bindable private var coordinator: ActivityListCoordinator

    // MARK: - init
    
    public init(coordinator: ActivityListCoordinator) {
        self.coordinator = coordinator
    }

    // MARK: - Body
    
    public var body: some View {
        NavigationStack(path: $coordinator.path) {
            ActivityListView(viewModel: coordinator.listViewModel)
                .navigationDestination(for: SportActivity.self) { activity in
                    ActivityDetailView(
                        viewModel: coordinator.detailViewModel(for: activity)
                    )
                }
        }
    }
}
