//
//  AddActivityCoordinatorView.swift
//  AddActivity
//
//  Created by Miroslav Tourek on 15.04.2026.
//

import SwiftUI

public struct AddActivityCoordinatorView: View {
    
    // MARK: - Properties
    
    private var coordinator: AddActivityCoordinator
    
    // MARK: - init
    
    public init(coordinator: AddActivityCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: - Body
    
    public var body: some View {
        NavigationStack {
            AddActivityView(viewModel: coordinator.viewModel)
        }
    }
}
