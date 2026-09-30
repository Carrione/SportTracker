//
//  MockAnalyticsService.swift
//  SharedDomain
//
//  Created by Miroslav Tourek on 13.04.2026.
//

import SharedDomain

final class MockAnalyticsService: AnalyticsServiceProtocol, @unchecked Sendable {
    var loggedEvents: [AnalyticsEvent] = []
    
    func logEvent(_ event: AnalyticsEvent) {
        loggedEvents.append(event)
    }
}
