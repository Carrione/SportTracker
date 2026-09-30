//
//  SportActivity.swift
//  SharedDomain
//
//  Created by Miroslav Tourek on 13.04.2026.
//

import Foundation

public struct SportActivity: Identifiable, Equatable, Hashable, Sendable {
    public let id: UUID
    public let name: String
    public let location: String
    public let duration: Duration
    public let storageType: StorageType
    public let createdAt: Date
    
    public init(
        id: UUID = UUID(),
        name: String,
        location: String,
        duration: Duration,
        storageType: StorageType,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.location = location
        self.duration = duration
        self.storageType = storageType
        self.createdAt = createdAt
    }
}
