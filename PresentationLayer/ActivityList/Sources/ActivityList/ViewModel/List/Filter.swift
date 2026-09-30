//
//  Filter.swift
//  ActivityList
//
//  Created by Miroslav Tourek on 14.04.2026.
//

import SharedDomain
import SwiftUI

enum Filter: String, CaseIterable, Hashable, Sendable {
    case all = "All"
    case local = "Local"
    case remote = "Remote"

    var activityFilter: ActivityFilter {
        switch self {
        case .all: .all
        case .local: .byStorage(.local)
        case .remote: .byStorage(.remote)
        }
    }
}
