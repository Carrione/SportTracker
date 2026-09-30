//
//  SwiftDataActivityRepository.swift
//  SwiftDataToolkit
//
//  Created by Miroslav Tourek on 13.04.2026.
//

import Foundation
import SharedDomain
import SwiftData

// MARK: - AuthError

private enum AuthError: LocalizedError {
    case notAuthenticated

    var errorDescription: String? {
        "You must be signed in to save or access local activities."
    }
}

@MainActor
public final class SwiftDataActivityRepository: PurgeableActivityStore {
    private let modelContainer: ModelContainer
    private let authService: any AuthServiceProtocol
    
    private var modelContext: ModelContext { modelContainer.mainContext }
    
    public init(modelContainer: ModelContainer, authService: some AuthServiceProtocol) {
        self.modelContainer = modelContainer
        self.authService = authService
    }

    public func save(_ activity: SportActivity) async throws {
        guard let userID = authService.uid else {
            throw ActivityRepositoryError.saveFailed(underlying: AuthError.notAuthenticated)
        }
        let record = ActivityRecord(from: activity, userID: userID)
        modelContext.insert(record)
        do {
            try modelContext.save()
        } catch {
            throw ActivityRepositoryError.saveFailed(underlying: error)
        }
    }

    public func fetchAll() async throws -> [SportActivity] {
        guard let userID = authService.uid else { return [] }
        let descriptor = FetchDescriptor<ActivityRecord>(
            predicate: #Predicate { $0.userID == userID },
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        do {
            let records = try modelContext.fetch(descriptor)
            return records.map { $0.toDomain() }
        } catch {
            throw ActivityRepositoryError.fetchFailed(underlying: error)
        }
    }

    public func deleteAll() async throws {
        guard let userID = authService.uid else { return }
        do {
            try modelContext.delete(
                model: ActivityRecord.self,
                where: #Predicate { $0.userID == userID }
            )
            try modelContext.save()
        } catch {
            throw ActivityRepositoryError.deleteFailed(underlying: error)
        }
    }

    public func delete(_ activity: SportActivity) async throws {
        guard let userID = authService.uid else {
            throw ActivityRepositoryError.deleteFailed(underlying: AuthError.notAuthenticated)
        }
        
        let id = activity.id
        let descriptor = FetchDescriptor<ActivityRecord>(
            predicate: #Predicate { $0.activityID == id && $0.userID == userID }
        )
        
        do {
            let records = try modelContext.fetch(descriptor)
            guard let record = records.first else { throw ActivityRepositoryError.notFound }
            modelContext.delete(record)
            try modelContext.save()
        } catch let error as ActivityRepositoryError {
            throw error
        } catch {
            throw ActivityRepositoryError.deleteFailed(underlying: error)
        }
    }
}
