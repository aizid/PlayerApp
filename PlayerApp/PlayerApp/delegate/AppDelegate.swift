//
//  AppDelegate.swift
//  PlayerApp
//
//  Created by IOS-Cakra on 06/09/26.
//

import UIKit
import RealmSwift
import FirebaseCore
#if DEBUG
import netfox
#endif

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let appDIContainer = AppDIContainer()
    var appFlowCoordinator: AppFlowCoordinator?
    
    var window: UIWindow?
    var realm: Realm!
    
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
        appFlowCoordinator?.start()
        
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
}


// MARK: Setup Aplication
extension AppDelegate {
    private func setupRealmConfig() {
        appDIContainer.appDelegate = self
        let realmVersion = UInt64(ConstantProp.REALM_VERS) ?? 1
        let encryptedKey = GlobalFunc.getAppProperties().ENCRYPTED_KEY!
        var key = NSData(data: encryptedKey.data(using: .ascii) ?? Data())
        
        if key.length != 64 {
            let mutableKey: NSMutableData = key.mutableCopy() as! NSMutableData
            mutableKey.length = 64
            key = mutableKey.mutableCopy() as! NSData
        }
        
        let realmConfig = Realm.Configuration(
            encryptionKey: key as Data,
            schemaVersion: realmVersion,
            migrationBlock: {
                migration, oldVersion in
                // Check if schema version has changed
                if oldVersion < realmVersion {
                    print("Schema version mismatch. Clearing old Realm file...")
                    self.deleteRealmFile() // Clear old Realm data
                }
            })
            
        self.realm = try? Realm(configuration: realmConfig)
        
        print("Realm File : ", realmConfig.fileURL ?? "")
    }
    
    // Function to delete the Realm file
    private func deleteRealmFile() {
        if let fileURL = Realm.Configuration.defaultConfiguration.fileURL {
            do {
                let realmFolderURL = fileURL.deletingLastPathComponent()
                let realmFiles = try FileManager.default.contentsOfDirectory(at: realmFolderURL, includingPropertiesForKeys: nil)
                
                // Delete all files associated with Realm (including .realm, .lock, .note, etc.)
                for file in realmFiles where file.lastPathComponent.contains("default.realm") {
                    try FileManager.default.removeItem(at: file)
                    print("Deleted Realm file: \(file.lastPathComponent)")
                }
            } catch {
                print("Error deleting Realm files: \(error.localizedDescription)")
            }
        }
    }
}

