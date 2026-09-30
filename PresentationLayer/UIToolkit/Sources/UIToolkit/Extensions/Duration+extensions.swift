//
//  Duration+extensions.swift
//  UIToolkit
//
//  Created by Miroslav Tourek on 14.04.2026.
//

public extension Duration {
    var formatted: String {
        let (totalSeconds, _) = components
        if totalSeconds >= 3600 {
            return formatted(.time(pattern: .hourMinuteSecond))
        } else {
            return formatted(.time(pattern: .minuteSecond))
        }
    }
}
