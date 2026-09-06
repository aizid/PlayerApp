//
//  AppSceneDIContainer.swift
//  PlayerApp
//
//  Created by IOS-Cakra on 06/09/26.
//
import Foundation
import UIKit

final class AppSceneDIContainer {
    
    struct Dependencies {
        let playerRemoteDataSource: AppRemoteDataSource
        let localDataSource: LocalDataSource
    }
    
    private let dependencies: Dependencies
    private let appDelegate: AppDelegate?
    
    init(dependencies: Dependencies, appDelegate: AppDelegate?) {
        self.dependencies = dependencies
        self.appDelegate = appDelegate
    }
    
    
    // MARK: - Use Cases
    
    func makeMainUseCase() -> MainUseCase {
        return DefaultMainUseCase(appRepository: makeAppRepository())
    }
    
    
    // MARK: - Repositories
    func makeAppRepository() -> AppRepository {
        return DefaultAppRepository(appRemoteDataSource: dependencies.playerRemoteDataSource, localDataSource: dependencies.localDataSource)
    }
    
    
    // MARK: - Launch
    func makeLaunchVC(closures: LaunchVMClosures) -> LaunchVC {
        return LaunchVC.create(with: makeLaunchVM(closures: closures))
    }
    
    func makeLaunchVM(closures: LaunchVMClosures) -> LaunchVM {
        return DefaultLaunchVM(closures: closures)
    }
    
    // MARK: - Main
    func makeMainVC(closures: MainVMClosures) -> MainVC {
        return MainVC.create(with: makeMainVM(closures: closures))
    }
    
    func makeMainVM(closures: MainVMClosures) -> MainVM {
        return DefaultMainVM(mainUseCase: makeMainUseCase(), closures: closures)
    }
}
