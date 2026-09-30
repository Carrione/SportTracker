//
//  ActivityDocument.swift
//  FirebaseToolkit
//
//  Created by Miroslav Tourek on 13.04.2026.
//

import Foundation
import SharedDomain

/// Firestore representation of a ``SportActivity``
struct ActivityDocument: Codable {
    let id: String
    let name: String
    let location: String
    let durationSeconds: Int64
    let createdAt: Date
}

// MARK: - Domain mapping

extension ActivityDocument {
    init(from activity: SportActivity) {
        let (seconds, _) = activity.duration.components

        self.init(
            id: activity.id.uuidString,
            name: activity.name,
            location: activity.location,
            durationSeconds: seconds,
            createdAt: activity.createdAt
        )
    }

    func toDomain() -> SportActivity? {
        guard let id = UUID(uuidString: id) else { return nil }

        return SportActivity(
            id: id,
            name: name,
            location: location,
            duration: .seconds(durationSeconds),
            storageType: .remote,
            createdAt: createdAt
        )
    }
}
