//
//  FirebaseActivityRepository.swift
//  FirebaseToolkit
//
//  Created by Miroslav Tourek on 13.04.2026.
//

import FirebaseFirestore
import SharedDomain

// MARK: - AuthError

private enum AuthError: LocalizedError {
    case notAuthenticated
    
    var errorDescription: String? {
        "You must be signed in to save or access remote activities."
    }
}

@MainActor
public final class FirebaseActivityRepository: SportActivityStore {
    
    // MARK: - Properties
    
    private let db = Firestore.firestore()
    private let authService: any AuthServiceProtocol
    private let crashlyticsService: any CrashlyticsServiceProtocol

    private var activitiesCollection: CollectionReference? {
        guard let uid = authService.uid else { return nil }
        return db.collection("users").document(uid).collection("activities")
    }

    // MARK: - init

    public init(
        authService: some AuthServiceProtocol,
        crashlyticsService: some CrashlyticsServiceProtocol
    ) {
        self.authService = authService
        self.crashlyticsService = crashlyticsService
    }
    
    // MARK: - Functions
    
    public func save(_ activity: SportActivity) async throws {
        guard let collection = activitiesCollection else {
            throw ActivityRepositoryError.saveFailed(underlying: AuthError.notAuthenticated)
        }
        do {
            let data = try Firestore.Encoder().encode(ActivityDocument(from: activity))
            try await collection.document(activity.id.uuidString).setData(data)
        } catch {
            throw ActivityRepositoryError.saveFailed(underlying: error)
        }
    }

    public func fetchAll() async throws -> [SportActivity] {
        guard let collection = activitiesCollection else { return [] }
        do {
            let snapshot = try await collection
                .order(by: "createdAt", descending: true)
                .getDocuments()
            return snapshot.documents.compactMap(decodeActivity)
        } catch {
            throw ActivityRepositoryError.fetchFailed(underlying: error)
        }
    }
    
    public func delete(_ activity: SportActivity) async throws {
        guard let collection = activitiesCollection else {
            throw ActivityRepositoryError.deleteFailed(underlying: AuthError.notAuthenticated)
        }
        do {
            try await collection.document(activity.id.uuidString).delete()
        } catch {
            throw ActivityRepositoryError.deleteFailed(underlying: error)
        }
    }

    private func decodeActivity(from document: QueryDocumentSnapshot) -> SportActivity? {
        do {
            guard let activity = try document.data(as: ActivityDocument.self).toDomain() else {
                crashlyticsService.log("Skipped activity \(document.documentID): identifier is not a valid UUID.")
                return nil
            }
            return activity
        } catch {
            crashlyticsService.log("Skipped activity \(document.documentID): decoding failed.")
            crashlyticsService.logNonFatal(error: error)
            return nil
        }
    }
}
