//
//  StorageType.swift
//  SharedDomain
//
//  Created by Miroslav Tourek on 13.04.2026.
//

public enum StorageType: String, CaseIterable, Hashable, Sendable, Codable {
    case local
    case remote
    
    public var displayName: String {
        switch self {
        case .local: "Local"
        case .remote: "Remote"
        }
    }
}
