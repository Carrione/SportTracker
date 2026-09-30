//
//  ActivityDetailViewModel.swift
//  ActivityList
//
//  Created by Miroslav Tourek on 14.04.2026.
//

import Observation
import SharedDomain

// MARK: - State

extension ActivityDetailViewModel {
    struct State {
        var activity: SportActivity
    }
}

@Observable
@MainActor
final class ActivityDetailViewModel {
    private(set) var state: State
    
    // MARK: - init
    
    init(activity: SportActivity) {
        self.state = State(activity: activity)
    }
}
