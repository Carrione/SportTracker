//
//  SwiftDataStack.swift
//  SwiftDataProvider
//
//  Created by Miroslav Tourek on 13.04.2026.
//

import SwiftData
import SwiftDataToolkit

@MainActor
public final class SwiftDataStack {
    public let modelContainer: ModelContainer

    public init() {
        do {
            modelContainer = try ModelContainer(for: ActivityRecord.self)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }

    public var mainContext: ModelContext {
        modelContainer.mainContext
    }
}
