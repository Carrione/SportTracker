//
//  Repositories.swift
//  DependencyInjection
//
//  Created by Miroslav Tourek on 13.04.2026.
//

import SharedDomain

public extension InjectedValues {
    var sportActivityRepository: any SportActivityRepository {
        get {
            guard let repo = self[SportActivityRepositoryKey.self] else {
                fatalError("SportActivityRepository not registered — call DependencyRegistration.registerAll() first")
            }
            return repo
        }
        set { self[SportActivityRepositoryKey.self] = newValue }
    }
}

private struct SportActivityRepositoryKey: InjectionKey {
    nonisolated(unsafe) static var currentValue: (any SportActivityRepository)? = nil
}
