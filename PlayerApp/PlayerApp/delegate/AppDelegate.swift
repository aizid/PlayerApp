//
//  AppDelegate.swift
//  PlayerApp
//
//  Created by IOS-Cakra on 06/09/26.
//

import UIKit
import FirebaseCore
#if DEBUG
import netfox
#endif

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let appDIContainer = AppDIContainer()
    var appFlowCoordinator: AppFlowCoordinator?
    
    var window: UIWindow?
    
    var allowRotation = false {
        didSet {
            if !allowRotation {
                forcePortraitOrientation()
            }
        }
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return allowRotation ? [.portrait, .landscapeLeft, .landscapeRight] : .portrait
    }
    
    private func forcePortraitOrientation() {
        DispatchQueue.main.async {
            guard UIApplication.shared.connectedScenes.first is UIWindowScene else { return }
            
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            UIViewController.attemptRotationToDeviceOrientation()
        }
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        AppAppearance.setupAppearance()
        FirebaseApp.configure()
        
        //Netfox networking debug
        #if DEBUG
        NFX.sharedInstance().start()
        #endif
        
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController()
        
        window?.rootViewController = navigationController
        appFlowCoordinator = AppFlowCoordinator(navigationController: navigationController, appDIContainer: appDIContainer)
        
        
        //Set netfox network debug gesture repeat tap
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openNetfox))
        tapGesture.numberOfTapsRequired = 5
        window?.addGestureRecognizer(tapGesture)
        
        
        window?.makeKeyAndVisible()
        print("App Start")
        
        return true
    }
    
    @objc private func openNetfox() {
    #if DEBUG
        NFX.sharedInstance().show()
    #endif
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

