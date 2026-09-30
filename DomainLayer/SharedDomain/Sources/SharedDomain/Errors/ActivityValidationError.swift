//
//  ActivityValidationError.swift
//  SharedDomain
//
//  Created by Miroslav Tourek on 13.04.2026.
//

import Foundation

public enum ActivityValidationError: LocalizedError, Equatable, Sendable {
    case emptyName
    case emptyLocation
    case zeroDuration
    
    public var errorDescription: String? {
        switch self {
        case .emptyName: "Activity name cannot be empty"
        case .emptyLocation: "Location cannot be empty"
        case .zeroDuration: "Duration must be greater than zero"
        }
    }
}
