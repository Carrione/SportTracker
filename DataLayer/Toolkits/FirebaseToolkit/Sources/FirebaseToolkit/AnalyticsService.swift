//
//  AnalyticsService.swift
//  FirebaseToolkit
//
//  Created by Miroslav Tourek on 13.04.2026.
//

import FirebaseAnalytics
import SharedDomain

public final class AnalyticsService: AnalyticsServiceProtocol, Sendable {
    public init() {}
    
    public func logEvent(_ event: AnalyticsEvent) {
        Analytics.logEvent(
            event.name,
            parameters: event.parameters.isEmpty ? nil : event.parameters
        )
    }
}
