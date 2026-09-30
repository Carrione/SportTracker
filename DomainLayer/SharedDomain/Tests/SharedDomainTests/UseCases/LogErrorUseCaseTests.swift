//
//  LogErrorUseCaseTests.swift
//  SharedDomain
//
//  Created by Miroslav Tourek on 16.04.2026.
//

@testable import SharedDomain
import Testing

@Suite("LogErrorUseCase")
struct LogErrorUseCaseTests {
    
    @Test("logs error to crashlytics")
    func execute_logsError() {
        let mock = MockCrashlyticsService()
        let useCase = LogErrorUseCaseImpl(crashlytics: mock)
        let error = ActivityRepositoryError.notFound
        
        useCase.execute(error: error)
        
        #expect(mock.loggedErrors.count == 1)
    }
}
