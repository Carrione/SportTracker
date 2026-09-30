//
//  SaveActivityUseCaseTests.swift
//  SharedDomain
//
//  Created by Miroslav Tourek on 16.04.2026.
//

@testable import SharedDomain
import Testing

@Suite("SaveActivityUseCase")
struct SaveActivityUseCaseTests {
    
    @Test("valid input saves activity")
    func validInput_savesActivity() async throws {
        let mock = MockSportActivityRepository()
        let useCase = SaveActivityUseCaseImpl(repository: mock)
        
        try await useCase.execute(
            name: "Morning Run",
            location: "Park",
            duration: .seconds(3600),
            storageType: .local
        )
        
        #expect(mock.savedActivities.count == 1)
        #expect(mock.savedActivities[0].name == "Morning Run")
        #expect(mock.savedActivities[0].location == "Park")
        #expect(mock.savedActivities[0].storageType == .local)
    }
    
    @Test("trims whitespace from name and location")
    func trimsWhitespace() async throws {
        let mock = MockSportActivityRepository()
        let useCase = SaveActivityUseCaseImpl(repository: mock)
        
        try await useCase.execute(
            name: "  Run  ",
            location: "  Park  ",
            duration: .seconds(1800),
            storageType: .remote
        )
        
        #expect(mock.savedActivities[0].name == "Run")
        #expect(mock.savedActivities[0].location == "Park")
    }
    
    @Test("empty name throws validation error")
    func emptyName_throwsError() async throws {
        let mock = MockSportActivityRepository()
        let useCase = SaveActivityUseCaseImpl(repository: mock)
        
        await #expect(throws: ActivityValidationError.emptyName) {
            try await useCase.execute(
                name: "   ",
                location: "Park",
                duration: .seconds(3600),
                storageType: .local
            )
        }
    }
    
    @Test("empty location throws validation error")
    func emptyLocation_throwsError() async throws {
        let mock = MockSportActivityRepository()
        let useCase = SaveActivityUseCaseImpl(repository: mock)
        
        await #expect(throws: ActivityValidationError.emptyLocation) {
            try await useCase.execute(
                name: "Run",
                location: "",
                duration: .seconds(3600),
                storageType: .local
            )
        }
    }
    
    @Test("zero duration throws validation error")
    func zeroDuration_throwsError() async throws {
        let mock = MockSportActivityRepository()
        let useCase = SaveActivityUseCaseImpl(repository: mock)
        
        await #expect(throws: ActivityValidationError.zeroDuration) {
            try await useCase.execute(
                name: "Run",
                location: "Park",
                duration: .zero,
                storageType: .local
            )
        }
    }
}
