//
//  SportTrackerApp.swift
//  SportTracker
//
//  Created by Miroslav Tourek on 13.04.2026.
//

import DependencyInjection
import FirebaseProvider
import SwiftUI

@main
struct SportTrackerApp: App {
    // Explicit State init to guarantee ordering: Firebase → DI → Coordinator
    @State private var coordinator: AppCoordinator
    
    init() {
        FirebaseProvider.configure()                         // 1. Firebase first
        DependencyRegistration.registerAll()                 // 2. Register into InjectedValues
        _coordinator = State(wrappedValue: AppCoordinator()) // 3. Coordinators
    }
    
    var body: some Scene {
        WindowGroup {
            RootView(coordinator: coordinator)
        }
    }
}
