//
//  DependencyContainer.swift
//  DependencyInjection
//
//  Created by Miroslav Tourek on 13.04.2026.
//

public protocol InjectionKey {
    associatedtype Value
    static var currentValue: Value? { get set }
}

@MainActor
public struct InjectedValues {
    public static var current = InjectedValues()
    
    public subscript<K: InjectionKey>(key: K.Type) -> K.Value? {
        get { K.currentValue }
        set { K.currentValue = newValue }
    }
}

@propertyWrapper
public struct Injected<T> {
    private let keyPath: KeyPath<InjectedValues, T>
    
    public init(_ keyPath: KeyPath<InjectedValues, T>) {
        self.keyPath = keyPath
    }
    
    @MainActor
    public var wrappedValue: T {
        InjectedValues.current[keyPath: keyPath]
    }
}
