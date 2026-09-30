//
//  ActivityListViewModel.swift
//  ActivityList
//
//  Created by Miroslav Tourek on 13.04.2026.
//

import DependencyInjection
import Observation
import SharedDomain

// MARK: - Delegate protocol

@MainActor
protocol ActivityListViewModelDelegate: AnyObject {
    func activitySelected(_ activity: SportActivity)
}

// MARK: - State

extension ActivityListViewModel {
    struct State {
        var activities: [SportActivity] = []
        var selectedFilter: Filter = .all
        var isLoading: Bool = false
        var errorMessage: String?
    }
}

@Observable
@MainActor
final class ActivityListViewModel {
    private(set) var state: State = State()
    
    // MARK: - Properties
    
    weak var delegate: (any ActivityListViewModelDelegate)?
    
    @ObservationIgnored private var fetchTask: Task<Void, Never>?
    
    @ObservationIgnored @Injected(\.fetchActivitiesUseCase) private var fetchUseCase
    @ObservationIgnored @Injected(\.deleteActivityUseCase) private var deleteUseCase
    @ObservationIgnored @Injected(\.logErrorUseCase) private var logErrorUseCase
    @ObservationIgnored @Injected(\.logEventUseCase) private var logEventUseCase
    
    // MARK: - Intent
    
    enum ActivityListIntent {
        case onAppear
        case selectFilter(Filter)
        case delete(SportActivity)
        case showDetail(SportActivity)
        case clearError
    }
    
    func onIntent(_ intent: ActivityListIntent) {
        switch intent {
        case .onAppear:
            startFetching()
        case let .selectFilter(filter):
            state.selectedFilter = filter
            startFetching()
        case let .delete(activity):
            Task { await deleteActivity(activity) }
        case let .showDetail(activity):
            delegate?.activitySelected(activity)
        case .clearError:
            state.errorMessage = nil
        }
    }
    
    // MARK: - Private functions
    
    private func startFetching() {
        fetchTask?.cancel()
        fetchTask = Task { await fetchActivities() }
    }
    
    private func fetchActivities() async {
        state.isLoading = true
        state.errorMessage = nil
        do {
            for try await activities in fetchUseCase.stream(filter: state.selectedFilter.activityFilter) {
                state.activities = activities
            }
            state.isLoading = false
        } catch {
            logErrorUseCase.execute(error: error)
            state.errorMessage = error.localizedDescription
            state.isLoading = false
        }
    }
    
    private func deleteActivity(_ activity: SportActivity) async {
        do {
            try await deleteUseCase.execute(activity)
            logEventUseCase.execute(event: .activityDeleted(storageType: activity.storageType))
            state.activities.removeAll { $0.id == activity.id }
        } catch {
            logErrorUseCase.execute(error: error)
            state.errorMessage = error.localizedDescription
        }
    }
}
