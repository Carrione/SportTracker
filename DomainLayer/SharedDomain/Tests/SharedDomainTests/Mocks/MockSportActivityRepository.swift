//
//  MockSportActivityRepository.swift
//  SharedDomain
//
//  Created by Miroslav Tourek on 13.04.2026.
//

import SharedDomain

final class MockSportActivityRepository: SportActivityRepository, @unchecked Sendable {
    var activitiesToReturn: [SportActivity]
    var savedActivities: [SportActivity] = []
    var deletedActivities: [SportActivity] = []
    var shouldThrow: Error? = nil
    var deleteAllLocalCallCount = 0
    
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
    
    func deleteAllLocalActivities() async throws {
        if let error = shouldThrow { throw error }
        deleteAllLocalCallCount += 1
    }
    
    func stream(filter: ActivityFilter) -> AsyncThrowingStream<[SportActivity], Error> {
        AsyncThrowingStream { continuation in
            Task {
                if let error = self.shouldThrow {
                    continuation.finish(throwing: error)
                    return
                }
                let results: [SportActivity]
                switch filter {
                case .all:
                    results = self.activitiesToReturn
                case .byStorage(let storageType):
                    results = self.activitiesToReturn.filter { $0.storageType == storageType }
                }
                continuation.yield(results)
                continuation.finish()
            }
        }
    }
}
