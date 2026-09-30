//
//  ActivityFilter.swift
//  SharedDomain
//
//  Created by Miroslav Tourek on 13.04.2026.
//

public enum ActivityFilter: Hashable, Sendable {
    case all
    case byStorage(StorageType)
}
