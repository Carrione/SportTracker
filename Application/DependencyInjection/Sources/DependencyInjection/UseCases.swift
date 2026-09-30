//
//  UseCases.swift
//  DependencyInjection
//
//  Created by Miroslav Tourek on 13.04.2026.
//

import SharedDomain

public extension InjectedValues {
    var saveActivityUseCase: any SaveActivityUseCase {
        SaveActivityUseCaseImpl(repository: sportActivityRepository)
    }
    
    var fetchActivitiesUseCase: any FetchActivitiesUseCase {
        FetchActivitiesUseCaseImpl(repository: sportActivityRepository)
    }
    
    var deleteActivityUseCase: any DeleteActivityUseCase {
        DeleteActivityUseCaseImpl(repository: sportActivityRepository)
    }
    
    var signOutUseCase: any SignOutUseCase {
        SignOutUseCaseImpl(authService: authService, repository: sportActivityRepository)
    }

    var logErrorUseCase: any LogErrorUseCase {
        LogErrorUseCaseImpl(crashlytics: crashlyticsService)
    }
    
    var logEventUseCase: any LogEventUseCase {
        LogEventUseCaseImpl(analytics: analyticsService)
    }
}
