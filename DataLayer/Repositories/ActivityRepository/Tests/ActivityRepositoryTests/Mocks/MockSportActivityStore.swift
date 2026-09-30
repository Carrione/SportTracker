//
//  MockSportActivityStore.swift
//  ActivityRepository
//
//  Created by Miroslav Tourek on 13.04.2026.
//

import SharedDomain

final class MockSportActivityStore: PurgeableActivityStore, @unchecked Sendable {
    var activitiesToReturn: [SportActivity]
    var savedActivities: [SportActivity] = []
    var deletedActivities: [SportActivity] = []
    var shouldThrow: Error? = nil

    init(activitiesToReturn: [SportActivity] = []) {
        self.activitiesToReturn = activitiesToReturn
    }

    func save(_ activity: SportActivity) async throws {
        if let error = shouldThrow { throw error }
        savedActivities.append(activity)
    }

    func delete(_ activity: SportActivity) async throws {
        if let error = shouldThrow { throw error }
        deletedActivities.append(activity)
    }

    private(set) var didDeleteAll = false

    func deleteAll() async throws {
        if let error = shouldThrow { throw error }
        didDeleteAll = true
        activitiesToReturn = []
    }

    func fetchAll() async throws -> [SportActivity] {
        if let error = shouldThrow { throw error }
        return activitiesToReturn
    }
}
