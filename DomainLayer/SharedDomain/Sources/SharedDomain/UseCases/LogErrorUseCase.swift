//
//  LogErrorUseCase.swift
//  SharedDomain
//
//  Created by Miroslav Tourek on 13.04.2026.
//

public protocol LogErrorUseCase: Sendable {
    func execute(error: Error)
}

public struct LogErrorUseCaseImpl: LogErrorUseCase {
    private let crashlytics: any CrashlyticsServiceProtocol
    
    public init(crashlytics: some CrashlyticsServiceProtocol) {
        self.crashlytics = crashlytics
    }
    
    public func execute(error: Error) {
        crashlytics.logNonFatal(error: error)
    }
}
