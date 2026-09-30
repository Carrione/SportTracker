//
//  SportActivityStore.swift
//  SharedDomain
//
//  Created by Miroslav Tourek on 13.04.2026.
//

public protocol SportActivityStore: Sendable {
    func save(_ activity: SportActivity) async throws
    func delete(_ activity: SportActivity) async throws
    /// Returns all activities sorted by `createdAt`, newest first.
    func fetchAll() async throws -> [SportActivity]
}
