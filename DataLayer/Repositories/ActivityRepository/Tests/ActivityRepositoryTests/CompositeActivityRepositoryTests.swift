//
//  CompositeActivityRepositoryTests.swift
//  ActivityRepository
//
//  Created by Miroslav Tourek on 13.04.2026.
//

@testable import ActivityRepository
import Foundation
import SharedDomain
import Testing

@Suite("CompositeActivityRepository")
struct CompositeActivityRepositoryTests {

    // MARK: - Helpers

    private static func makeActivity(
        name: String,
        storageType: StorageType,
        createdAt: Date
    ) -> SportActivity {
        SportActivity(
            name: name,
            location: "Park",
            duration: .seconds(3600),
            storageType: storageType,
            createdAt: createdAt
        )
    }

    private static let referenceDate = Date(timeIntervalSince1970: 1_000_000)

    private static func makeSUT() -> (
        sut: CompositeActivityRepository,
        local: MockSportActivityStore,
        remote: MockSportActivityStore
    ) {
        let local = MockSportActivityStore()
        let remote = MockSportActivityStore()
        return (CompositeActivityRepository(local: local, remote: remote), local, remote)
    }

    // MARK: - Routing

    @Test("saves local activity to the local store only")
    func save_localActivity_routesToLocalStore() async throws {
        let (sut, local, remote) = Self.makeSUT()
        let activity = Self.makeActivity(name: "Run", storageType: .local, createdAt: Self.referenceDate)

        try await sut.save(activity)

        #expect(local.savedActivities == [activity])
        #expect(remote.savedActivities.isEmpty)
    }

    @Test("saves remote activity to the remote store only")
    func save_remoteActivity_routesToRemoteStore() async throws {
        let (sut, local, remote) = Self.makeSUT()
        let activity = Self.makeActivity(name: "Swim", storageType: .remote, createdAt: Self.referenceDate)

        try await sut.save(activity)

        #expect(remote.savedActivities == [activity])
        #expect(local.savedActivities.isEmpty)
    }

    @Test("deletes from the store matching the activity storage type")
    func delete_routesByStorageType() async throws {
        let (sut, local, remote) = Self.makeSUT()
        let localActivity = Self.makeActivity(name: "Run", storageType: .local, createdAt: Self.referenceDate)
        let remoteActivity = Self.makeActivity(name: "Swim", storageType: .remote, createdAt: Self.referenceDate)

        try await sut.delete(localActivity)
        try await sut.delete(remoteActivity)

        #expect(local.deletedActivities == [localActivity])
        #expect(remote.deletedActivities == [remoteActivity])
    }

    // MARK: - Progressive loading

    @Test("filter all yields local results first, then local combined with remote")
    func streamAll_yieldsLocalThenCombined() async throws {
        let (sut, local, remote) = Self.makeSUT()
        let localActivity = Self.makeActivity(name: "Run", storageType: .local, createdAt: Self.referenceDate)
        let remoteActivity = Self.makeActivity(name: "Swim", storageType: .remote, createdAt: Self.referenceDate)
        local.activitiesToReturn = [localActivity]
        remote.activitiesToReturn = [remoteActivity]

        var emissions: [[SportActivity]] = []
        for try await activities in sut.stream(filter: .all) {
            emissions.append(activities)
        }

        #expect(emissions.count == 2)
        #expect(emissions.first == [localActivity])
        #expect(emissions.last?.count == 2)
    }

    @Test("filter all sorts the combined result from newest to oldest")
    func streamAll_sortsCombinedByNewestFirst() async throws {
        let (sut, local, remote) = Self.makeSUT()
        let older = Self.makeActivity(name: "Older", storageType: .local, createdAt: Self.referenceDate)
        let newer = Self.makeActivity(
            name: "Newer",
            storageType: .remote,
            createdAt: Self.referenceDate.addingTimeInterval(60)
        )
        local.activitiesToReturn = [older]
        remote.activitiesToReturn = [newer]

        var emissions: [[SportActivity]] = []
        for try await activities in sut.stream(filter: .all) {
            emissions.append(activities)
        }

        #expect(emissions.last?.map(\.name) == ["Newer", "Older"])
    }

    private static func makeUnsortedLocalActivities() -> [SportActivity] {
        [
            Self.makeActivity(name: "Older", storageType: .local, createdAt: Self.referenceDate),
            Self.makeActivity(
                name: "Newer",
                storageType: .local,
                createdAt: Self.referenceDate.addingTimeInterval(60)
            )
        ]
    }

    @Test("filter by storage passes the store order through without re-sorting")
    func streamByStorage_passesStoreOrderThrough() async throws {
        let (sut, local, _) = Self.makeSUT()
        local.activitiesToReturn = Self.makeUnsortedLocalActivities()

        var result: [SportActivity] = []
        for try await activities in sut.stream(filter: .byStorage(.local)) {
            result = activities
        }

        #expect(result.map(\.name) == ["Older", "Newer"])
    }

    @Test("filter all leaves the local store order untouched in the first emission")
    func streamAll_firstEmissionPassesLocalOrderThrough() async throws {
        let (sut, local, remote) = Self.makeSUT()
        local.activitiesToReturn = Self.makeUnsortedLocalActivities()
        remote.activitiesToReturn = []

        var emissions: [[SportActivity]] = []
        for try await activities in sut.stream(filter: .all) {
            emissions.append(activities)
        }

        #expect(emissions.first?.map(\.name) == ["Older", "Newer"])
    }

    @Test("filter by storage reads only the matching store")
    func streamByStorage_readsMatchingStoreOnly() async throws {
        let (sut, local, remote) = Self.makeSUT()
        local.activitiesToReturn = [
            Self.makeActivity(name: "Run", storageType: .local, createdAt: Self.referenceDate)
        ]
        remote.activitiesToReturn = [
            Self.makeActivity(name: "Swim", storageType: .remote, createdAt: Self.referenceDate)
        ]

        var result: [SportActivity] = []
        for try await activities in sut.stream(filter: .byStorage(.remote)) {
            result = activities
        }

        #expect(result.map(\.name) == ["Swim"])
    }

    // MARK: - Local purge

    @Test("deleting all local activities touches the local store only")
    func deleteAllLocalActivities_purgesLocalStoreOnly() async throws {
        let (sut, local, remote) = Self.makeSUT()

        try await sut.deleteAllLocalActivities()

        #expect(local.didDeleteAll)
        #expect(!remote.didDeleteAll)
    }

    // MARK: - Error propagation

    @Test("propagates store errors through the stream")
    func stream_propagatesStoreError() async throws {
        let (sut, local, _) = Self.makeSUT()
        local.shouldThrow = ActivityRepositoryError.notFound

        await #expect(throws: ActivityRepositoryError.self) {
            for try await _ in sut.stream(filter: .all) {}
        }
    }
}
