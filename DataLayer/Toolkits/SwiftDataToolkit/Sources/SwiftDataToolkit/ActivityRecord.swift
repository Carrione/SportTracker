//
//  ActivityRecord.swift
//  SwiftDataToolkit
//
//  Created by Miroslav Tourek on 13.04.2026.
//

import Foundation
import SharedDomain
import SwiftData

@Model
public final class ActivityRecord {
    public var activityID: UUID
    public var userID: String
    public var name: String
    public var location: String
    public var durationSeconds: Double
    public var createdAt: Date
    
    @MainActor
    public init(from activity: SportActivity, userID: String) {
        self.activityID = activity.id
        self.userID = userID
        self.name = activity.name
        self.location = activity.location
        self.durationSeconds = activity.duration.timeInterval
        self.createdAt = activity.createdAt
    }
    
    @MainActor
    public func toDomain() -> SportActivity {
        SportActivity(
            id: activityID,
            name: name,
            location: location,
            duration: .seconds(durationSeconds),
            storageType: .local,
            createdAt: createdAt
        )
    }
}

private extension Duration {
    var timeInterval: Double {
        let (seconds, attoseconds) = components
        return Double(seconds) + Double(attoseconds) / 1e18
    }
}
