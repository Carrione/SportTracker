//
//  CrashlyticsService.swift
//  FirebaseToolkit
//
//  Created by Miroslav Tourek on 13.04.2026.
//

import FirebaseCrashlytics
import SharedDomain

public final class CrashlyticsService: CrashlyticsServiceProtocol, Sendable {
    public init() {}
    
    public func logNonFatal(error: Error) {
        Crashlytics.crashlytics().record(error: error)
    }
    
    public func log(_ message: String) {
        Crashlytics.crashlytics().log(message)
    }
    
    public func setCustomValue(_ value: String, forKey key: String) {
        Crashlytics.crashlytics().setCustomValue(value, forKey: key)
    }
}
