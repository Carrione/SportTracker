//
//  PurgeableActivityStore.swift
//  SharedDomain
//
//  Created by Miroslav Tourek on 13.04.2026.
//

/// Store whose contents can be dropped for the current user.
///
/// Only the local store needs this. An anonymous account cannot be signed into again,
/// so once its owner signs out, its records are unreachable and stay on the device
/// forever. Remote data is deliberately excluded — deleting it is a server-side action
/// and a signed-out account may still be reachable through its provider.
public protocol PurgeableActivityStore: SportActivityStore {
    /// Deletes every activity owned by the currently signed-in user.
    func deleteAll() async throws
}
