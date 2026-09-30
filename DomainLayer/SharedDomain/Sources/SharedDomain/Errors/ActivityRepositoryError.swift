//
//  ActivityRepositoryError.swift
//  SharedDomain
//
//  Created by Miroslav Tourek on 13.04.2026.
//

import Foundation

public enum ActivityRepositoryError: LocalizedError, Equatable, Sendable {
    case saveFailed(underlying: Error)
    case fetchFailed(underlying: Error)
    case deleteFailed(underlying: Error)
    case notFound
    
    public var errorDescription: String? {
        switch self {
        case let .saveFailed(error): "Failed to save activity: \(error.localizedDescription)"
        case let .fetchFailed(error): "Failed to fetch activities: \(error.localizedDescription)"
        case let .deleteFailed(error): "Failed to delete activity: \(error.localizedDescription)"
        case .notFound: "Activity not found"
        }
    }
    
    public static func == (lhs: ActivityRepositoryError, rhs: ActivityRepositoryError) -> Bool {
        switch (lhs, rhs) {
        case (.saveFailed, .saveFailed): true
        case (.fetchFailed, .fetchFailed): true
        case (.deleteFailed, .deleteFailed): true
        case (.notFound, .notFound): true
        default: false
        }
    }
}
