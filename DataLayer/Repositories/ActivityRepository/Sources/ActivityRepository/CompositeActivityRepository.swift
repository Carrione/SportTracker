//
//  CompositeActivityRepository.swift
//  ActivityRepository
//
//  Created by Miroslav Tourek on 13.04.2026.
//

import SharedDomain

public final class CompositeActivityRepository: SportActivityRepository {

    // MARK: - Properties

    private let local: any PurgeableActivityStore
    private let remote: any SportActivityStore

    // MARK: - init

    public init(local: some PurgeableActivityStore, remote: some SportActivityStore) {
        self.local = local
        self.remote = remote
    }

    // MARK: - Functions

    public func save(_ activity: SportActivity) async throws {
        try await store(for: activity.storageType).save(activity)
    }

    public func delete(_ activity: SportActivity) async throws {
        try await store(for: activity.storageType).delete(activity)
    }

    public func deleteAllLocalActivities() async throws {
        try await local.deleteAll()
    }

    public func stream(filter: ActivityFilter) -> AsyncThrowingStream<[SportActivity], Error> {
        AsyncThrowingStream { continuation in
            Task {
                do {
                    switch filter {
                    case .all:
                        let localResults = try await self.local.fetchAll()
                        continuation.yield(localResults)
                        let remoteResults = try await self.remote.fetchAll()
                        continuation.yield((localResults + remoteResults).sortedByNewest)
                    case let .byStorage(storageType):
                        continuation.yield(try await self.store(for: storageType).fetchAll())
                    }
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }

    // MARK: - Private

    private func store(for storageType: StorageType) -> any SportActivityStore {
        switch storageType {
        case .local: local
        case .remote: remote
        }
    }
}

// MARK: - Array extension

private extension Array where Element == SportActivity {
    var sortedByNewest: [SportActivity] {
        sorted { $0.createdAt > $1.createdAt }
    }
}
