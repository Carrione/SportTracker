//
//  RootView.swift
//  SportTracker
//
//  Created by Miroslav Tourek on 13.04.2026.
//

import ActivityList
import AddActivity
import Profile
import SwiftUI

struct RootView: View {
    @Bindable var coordinator: AppCoordinator
    
    var body: some View {
        TabView(selection: $coordinator.selectedTab) {
            Tab(
                "Activities",
                systemImage: "list.bullet",
                value: AppCoordinator.Tab.activities
            ) {
                ActivityListCoordinatorView(coordinator: coordinator.listCoordinator)
            }
            
            Tab(
                "Add",
                systemImage: "plus.circle.fill",
                value: AppCoordinator.Tab.add
            ) {
                AddActivityCoordinatorView(coordinator: coordinator.addCoordinator)
            }
            
            Tab(
                "Profile",
                systemImage: "person.circle",
                value: AppCoordinator.Tab.profile
            ) {
                ProfileCoordinatorView(coordinator: coordinator.profileCoordinator)
            }
        }
        .task {
            await coordinator.prepareSession()
        }
        .onChange(of: coordinator.currentUserID) {
            coordinator.sessionUserChanged()
        }
        .sheet(isPresented: .constant(coordinator.needsAuthentication)) {
            ProfileCoordinatorView(coordinator: coordinator.profileCoordinator)
                .interactiveDismissDisabled()
        }
    }
}
