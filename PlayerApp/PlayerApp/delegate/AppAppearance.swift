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
    
    static func checkAndSetDarkModeIfTrue() {
        if #available(iOS 13.0, *) {
            if GlobalFunc.GET_KEYCHAIN_WRAPPER_BOOLEAN(key: Constant.KEY_DARK_MODE_IS_ON) {
                // Set dark mode
                UIApplication.shared.windows.forEach { window in
                    if let rootViewController = window.rootViewController {
                        // Set dark mode for the root view controller
                        rootViewController.overrideUserInterfaceStyle = .dark
                        
                        // Set dark mode for presented view controllers recursively
                        setDarkModeForPresentedViewControllers(rootViewController)
                    }
                }
            } else {
                // Set light mode (default)
                UIApplication.shared.windows.forEach { window in
                    if let rootViewController = window.rootViewController {
                        // Set dark mode for the root view controller
                        rootViewController.overrideUserInterfaceStyle = .light
                        
                        // Set dark mode for presented view controllers recursively
                        setDarkModeForPresentedViewControllers(rootViewController)
                    }
                }
            }
        } else {
            // Fallback for iOS versions prior to iOS 13
            // You might implement a different method for earlier iOS versions
            // For instance, you could manually set the appearance of your views to light or default.
            // This is just a placeholder to show that a different approach may be needed.
            print("Setting light mode or default manually or using a different approach for iOS versions prior to 13")
        }
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
