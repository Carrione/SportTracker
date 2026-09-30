//
//  MockCrashlyticsService.swift
//  SharedDomain
//
//  Created by Miroslav Tourek on 13.04.2026.
//

import SharedDomain

final class MockCrashlyticsService: CrashlyticsServiceProtocol, @unchecked Sendable {
    var loggedErrors: [Error] = []
    var loggedMessages: [String] = []
    
    func logNonFatal(error: Error) { loggedErrors.append(error) }
    func log(_ message: String) { loggedMessages.append(message) }
    func setCustomValue(_ value: String, forKey key: String) {}
}
