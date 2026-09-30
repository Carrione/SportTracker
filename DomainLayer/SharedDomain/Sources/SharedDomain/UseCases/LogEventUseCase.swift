//
//  LogEventUseCase.swift
//  SharedDomain
//
//  Created by Miroslav Tourek on 13.04.2026.
//

public protocol LogEventUseCase: Sendable {
    func execute(event: AnalyticsEvent)
}

public struct LogEventUseCaseImpl: LogEventUseCase {
    private let analytics: any AnalyticsServiceProtocol
    
    public init(analytics: some AnalyticsServiceProtocol) {
        self.analytics = analytics
    }
    
    public func execute(event: AnalyticsEvent) {
        analytics.logEvent(event)
    }
}
