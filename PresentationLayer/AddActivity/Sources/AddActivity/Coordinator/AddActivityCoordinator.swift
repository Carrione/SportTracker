//
//  AddActivityCoordinator.swift
//  AddActivity
//
//  Created by Miroslav Tourek on 15.04.2026.
//

import Observation

// MARK: - Delegate protocol

@MainActor
public protocol AddActivityCoordinatorDelegate: AnyObject {
    func activitySaved()
}

@Observable
@MainActor
public final class AddActivityCoordinator {
    
    // MARK: - Properties
    
    public weak var delegate: (any AddActivityCoordinatorDelegate)?
    private(set) var viewModel: AddActivityViewModel

    // MARK: - init

    public init(delegate: (any AddActivityCoordinatorDelegate)?) {
        let viewModel = AddActivityViewModel()
        self.viewModel = viewModel
        self.delegate = delegate
        viewModel.delegate = self
    }
}

// MARK: - AddActivityViewModelDelegate

extension AddActivityCoordinator: AddActivityViewModelDelegate {
    public func activitySaved() {
        delegate?.activitySaved()
    }
}
