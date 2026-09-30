//
//  AnalyticsEvent.swift
//  SharedDomain
//
//  Created by Miroslav Tourek on 13.04.2026.
//

public enum SignInMethod: String, Sendable {
    case anonymous
    case google
}

public enum AnalyticsEvent: Sendable {
    case activityAdded(storageType: StorageType)
    case activityDeleted(storageType: StorageType)
    case userSignedIn(method: SignInMethod)
    case userSignedOut
    case userLinkedWithGoogle
    
    public var name: String {
        switch self {
        case .activityAdded: "activity_added"
        case .activityDeleted: "activity_deleted"
        case .userSignedIn: "user_signed_in"
        case .userSignedOut: "user_signed_out"
        case .userLinkedWithGoogle: "user_linked_with_google"
        }
    }
    
    public var parameters: [String: String] {
        switch self {
        case let .activityAdded(storageType):
            ["storage_type": storageType.rawValue]
        case let .activityDeleted(storageType):
            ["storage_type": storageType.rawValue]
        case let .userSignedIn(method):
            ["method": method.rawValue]
        case .userSignedOut, .userLinkedWithGoogle:
            [:]
        }
    }
}
