//
//  FetchActivitiesUseCase.swift
//  SharedDomain
//
//  Created by Miroslav Tourek on 13.04.2026.
//

public protocol FetchActivitiesUseCase: Sendable {
    func stream(filter: ActivityFilter) -> AsyncThrowingStream<[SportActivity], Error>
}

public struct FetchActivitiesUseCaseImpl: FetchActivitiesUseCase {
    private let repository: any SportActivityRepository
    
    public init(repository: some SportActivityRepository) {
        self.repository = repository
    }
    
    public func stream(filter: ActivityFilter) -> AsyncThrowingStream<[SportActivity], Error> {
        repository.stream(filter: filter)
    }
}
