//
//  LogEventUseCaseTests.swift
//  SharedDomain
//
//  Created by Miroslav Tourek on 16.04.2026.
//

@testable import SharedDomain
import Testing

@Suite("LogEventUseCase")
struct LogEventUseCaseTests {
    
    @Test("logs event to analytics")
    func execute_logsEvent() {
        let mock = MockAnalyticsService()
        let useCase = LogEventUseCaseImpl(analytics: mock)
        
        useCase.execute(event: .activityAdded(storageType: .local))
        
        #expect(mock.loggedEvents.count == 1)
    }
    
    @Test("event name and parameters are correct")
    func activityAdded_eventNameAndParameters() {
        let mock = MockAnalyticsService()
        let useCase = LogEventUseCaseImpl(analytics: mock)
        
        useCase.execute(event: .activityAdded(storageType: .remote))
        
        #expect(mock.loggedEvents[0].name == "activity_added")
        #expect(mock.loggedEvents[0].parameters["storage_type"] == "remote")
    }
}
