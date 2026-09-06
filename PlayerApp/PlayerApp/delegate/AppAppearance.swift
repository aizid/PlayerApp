//
//  AppAppearance.swift
//  PlayerApp
//
//  Created by IOS-Cakra on 06/09/26.
//

import Foundation
import UIKit

final class AppAppearance {
    
    static func setupAppearance() {
        
    }
    
    private static func setDarkModeForPresentedViewControllers(_ viewController: UIViewController) {
        
    }
}

extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            let isDarkMode = traitCollection.userInterfaceStyle == .dark
            return isDarkMode ? .lightContent : .darkContent
        } else {
            return .default // Default status bar style for iOS 12 and earlier
        }
    }
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setNeedsStatusBarAppearanceUpdate() // Update status bar appearance when trait collection changes
    }
}
