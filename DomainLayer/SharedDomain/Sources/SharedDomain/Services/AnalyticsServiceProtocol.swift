//
//  AnalyticsServiceProtocol.swift
//  SharedDomain
//
//  Created by Miroslav Tourek on 13.04.2026.
//

public protocol AnalyticsServiceProtocol: Sendable {
    func logEvent(_ event: AnalyticsEvent)
}
