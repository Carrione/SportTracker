//
//  DeleteActivityUseCaseTests.swift
//  SharedDomain
//
//  Created by Miroslav Tourek on 16.04.2026.
//

@testable import SharedDomain
import Testing

@Suite("DeleteActivityUseCase")
struct DeleteActivityUseCaseTests {
    
    @Test("deletes the given activity")
    func execute_deletesActivity() async throws {
        let mock = MockSportActivityRepository()
        let activity = SportActivity(name: "Run", location: "Park", duration: .seconds(3600), storageType: .local)
        let useCase = DeleteActivityUseCaseImpl(repository: mock)
        
        try await useCase.execute(activity)
        
        #expect(mock.deletedActivities.count == 1)
        #expect(mock.deletedActivities[0].id == activity.id)
    }
    
    @Test("propagates repository errors")
    func execute_propagatesError() async throws {
        let mock = MockSportActivityRepository()
        mock.shouldThrow = ActivityRepositoryError.notFound
        let activity = SportActivity(name: "Run", location: "Park", duration: .seconds(3600), storageType: .local)
        let useCase = DeleteActivityUseCaseImpl(repository: mock)
        
        await #expect(throws: ActivityRepositoryError.notFound) {
            try await useCase.execute(activity)
        }
    }
}
