//
//  SportActivityRepository.swift
//  SharedDomain
//
//  Created by Miroslav Tourek on 13.04.2026.
//

public protocol SportActivityRepository: Sendable {
    func save(_ activity: SportActivity) async throws
    func delete(_ activity: SportActivity) async throws
    func stream(filter: ActivityFilter) -> AsyncThrowingStream<[SportActivity], Error>
    func deleteAllLocalActivities() async throws
}
