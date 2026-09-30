//
//  CrashlyticsServiceProtocol.swift
//  SharedDomain
//
//  Created by Miroslav Tourek on 13.04.2026.
//

public protocol CrashlyticsServiceProtocol: Sendable {
    func logNonFatal(error: Error)
    func log(_ message: String)
    func setCustomValue(_ value: String, forKey key: String)
}
