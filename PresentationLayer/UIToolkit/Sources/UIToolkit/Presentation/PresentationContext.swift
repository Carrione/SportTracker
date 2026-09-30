//
//  PresentationContext.swift
//  UIToolkit
//
//  Created by Miroslav Tourek on 13.04.2026.
//

import UIKit

/// Finds the view controller that UIKit-based SDKs should present from.
///
/// SwiftUI has no equivalent of a presenting view controller, yet some SDKs
/// (Google Sign-In among them) require one. Locating it is a presentation-layer
/// concern, so lower layers receive the result instead of searching for it.
public enum PresentationContext {

    /// The topmost presented view controller of the active foreground scene, if any.
    ///
    /// Walking up the presentation chain matters: presenting from the window's root
    /// while a sheet is open fails, because that root is already presenting.
    public static var topViewController: UIViewController? {
        let keyWindow = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .filter { $0.activationState == .foregroundActive }
            .flatMap(\.windows)
            .first { $0.isKeyWindow }

        var controller = keyWindow?.rootViewController

        while let presented = controller?.presentedViewController {
            controller = presented
        }

        return controller
    }
}
