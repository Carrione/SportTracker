//
//  Providers.swift
//  DependencyInjection
//
//  Created by Miroslav Tourek on 13.04.2026.
//

import SharedDomain

public extension InjectedValues {
    var authService: any AuthServiceProtocol {
        get {
            guard let service = self[AuthServiceKey.self] else {
                fatalError("AuthService not registered — call DependencyRegistration.registerAll() first")
            }
            return service
        }
        set { self[AuthServiceKey.self] = newValue }
    }
    
    var crashlyticsService: any CrashlyticsServiceProtocol {
        get {
            guard let service = self[CrashlyticsServiceKey.self] else {
                fatalError("CrashlyticsService not registered — call DependencyRegistration.registerAll() first")
            }
            return service
        }
        set { self[CrashlyticsServiceKey.self] = newValue }
    }
    
    var analyticsService: any AnalyticsServiceProtocol {
        get {
            guard let service = self[AnalyticsServiceKey.self] else {
                fatalError("AnalyticsService not registered — call DependencyRegistration.registerAll() first")
            }
            return service
        }
        set { self[AnalyticsServiceKey.self] = newValue }
    }
}

private struct AuthServiceKey: InjectionKey {
    nonisolated(unsafe) static var currentValue: (any AuthServiceProtocol)? = nil
}

private struct CrashlyticsServiceKey: InjectionKey {
    nonisolated(unsafe) static var currentValue: (any CrashlyticsServiceProtocol)? = nil
}

private struct AnalyticsServiceKey: InjectionKey {
    nonisolated(unsafe) static var currentValue: (any AnalyticsServiceProtocol)? = nil
}
