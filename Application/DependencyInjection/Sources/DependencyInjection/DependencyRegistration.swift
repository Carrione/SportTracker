//
//  DependencyRegistration.swift
//  DependencyInjection
//
//  Created by Miroslav Tourek on 13.04.2026.
//

import ActivityRepository
import FirebaseToolkit
import SwiftDataProvider
import SwiftDataToolkit
import UIToolkit

@MainActor
public enum DependencyRegistration {
    public static func registerAll() {
        let stack = SwiftDataStack()
        let auth = FirebaseAuthService { PresentationContext.topViewController }
        let crashlytics = CrashlyticsService()
        let analytics = AnalyticsService()
        
        InjectedValues.current.authService = auth
        InjectedValues.current.crashlyticsService = crashlytics
        InjectedValues.current.analyticsService = analytics
        InjectedValues.current.sportActivityRepository = CompositeActivityRepository(
            local:  SwiftDataActivityRepository(modelContainer: stack.modelContainer, authService: auth),
            remote: FirebaseActivityRepository(authService: auth, crashlyticsService: crashlytics)
        )
        // Use cases are computed — no registration needed
    }
}
