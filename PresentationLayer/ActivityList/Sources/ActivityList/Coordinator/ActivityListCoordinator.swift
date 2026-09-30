//
//  ActivityListCoordinator.swift
//  ActivityList
//
//  Created by Miroslav Tourek on 13.04.2026.
//

import Observation
import SharedDomain
import SwiftUI

@Observable
@MainActor
public final class ActivityListCoordinator {
    
    // MARK: - Properties
    
    public var path = NavigationPath()
    private(set) var listViewModel: ActivityListViewModel
    
    // MARK: - init
    
    public init() {
        let listViewModel = ActivityListViewModel()
        self.listViewModel = listViewModel
        listViewModel.delegate = self
    }
    
    // MARK: - Functions
    
    public func reloadActivities() {
        listViewModel.onIntent(.onAppear)
    }
    
    // MARK: Internal functions
    
    func detailViewModel(for activity: SportActivity) -> ActivityDetailViewModel {
        ActivityDetailViewModel(activity: activity)
    }
    
    // MARK: Private functions
    
    private func showDetail(for activity: SportActivity) {
        path.append(activity)
    }
}

// MARK: - ActivityListViewModelDelegate

extension ActivityListCoordinator: ActivityListViewModelDelegate {
    public func activitySelected(_ activity: SportActivity) {
        showDetail(for: activity)
    }
}
