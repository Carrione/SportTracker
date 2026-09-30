//
//  AppCoordinator.swift
//  SportTracker
//
//  Created by Miroslav Tourek on 13.04.2026.
//

import ActivityList
import AddActivity
import DependencyInjection
import Observation
import Profile
import SharedDomain

@Observable
@MainActor
final class AppCoordinator {
    
    // MARK: - Tabs
    
    enum Tab {
        case activities, add, profile
    }
    
    var selectedTab: Tab = .activities

    // MARK: - Properties

    let listCoordinator: ActivityListCoordinator
    let addCoordinator: AddActivityCoordinator
    let profileCoordinator: ProfileCoordinator

    private(set) var isSessionResolved: Bool = false

    var needsAuthentication: Bool { isSessionResolved && !authService.isSignedIn }

    var currentUserID: String? { authService.uid }

    @ObservationIgnored @Injected(\.authService) private var authService
    @ObservationIgnored @Injected(\.logErrorUseCase) private var logErrorUseCase

    // MARK: - init

    init() {
        self.listCoordinator = ActivityListCoordinator()
        self.profileCoordinator = ProfileCoordinator()
        let addCoordinator = AddActivityCoordinator(delegate: nil)
        self.addCoordinator = addCoordinator
        addCoordinator.delegate = self
    }

    // MARK: - Functions

    func sessionUserChanged() {
        listCoordinator.reloadActivities()
    }

    func prepareSession() async {
        defer { isSessionResolved = true }

        do {
            if !authService.isSignedIn {
                try await authService.signInAnonymously()
            } else if !authService.isAnonymous {
                try authService.signOut()
            }
        } catch {
            logErrorUseCase.execute(error: error)
        }
    }
}

// MARK: - AddActivityCoordinatorDelegate

extension AppCoordinator: AddActivityCoordinatorDelegate {
    func activitySaved() {
        listCoordinator.reloadActivities()
        selectedTab = .activities
    }
}
