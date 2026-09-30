//
//  FetchActivitiesUseCaseTests.swift
//  SharedDomain
//
//  Created by Miroslav Tourek on 16.04.2026.
//

@testable import SharedDomain
import Testing

@Suite("FetchActivitiesUseCase")
struct FetchActivitiesUseCaseTests {
    
    private static func makeActivities() -> [SportActivity] {
        [
            SportActivity(
                name: "Run",
                location: "Park",
                duration: .seconds(3600),
                storageType: .local
            ),
            SportActivity(
                name: "Swim",
                location: "Pool",
                duration: .seconds(1800),
                storageType: .remote
            ),
            SportActivity(
                name: "Bike",
                location: "Trail",
                duration: .seconds(7200),
                storageType: .local
            )
        ]
    }
    
    @Test("filter all returns all activities")
    func filterAll_returnsAll() async throws {
        let mock = MockSportActivityRepository(activitiesToReturn: Self.makeActivities())
        let useCase = FetchActivitiesUseCaseImpl(repository: mock)
        
        var result: [SportActivity] = []
        for try await activities in useCase.stream(filter: .all) {
            result = activities
        }
        
        #expect(result.count == 3)
    }
    
    @Test("filter by local returns only local activities")
    func filterByLocal_returnsLocal() async throws {
        let mock = MockSportActivityRepository(activitiesToReturn: Self.makeActivities())
        let useCase = FetchActivitiesUseCaseImpl(repository: mock)
        
        var result: [SportActivity] = []
        for try await activities in useCase.stream(filter: .byStorage(.local)) {
            result = activities
        }
        
        #expect(result.count == 2)
        #expect(result.allSatisfy { $0.storageType == .local })
    }
    
    @Test("filter by remote returns only remote activities")
    func filterByRemote_returnsRemote() async throws {
        let mock = MockSportActivityRepository(activitiesToReturn: Self.makeActivities())
        let useCase = FetchActivitiesUseCaseImpl(repository: mock)
        
        var result: [SportActivity] = []
        for try await activities in useCase.stream(filter: .byStorage(.remote)) {
            result = activities
        }
        
        #expect(result.count == 1)
        #expect(result.first?.storageType == .remote)
    }
}
