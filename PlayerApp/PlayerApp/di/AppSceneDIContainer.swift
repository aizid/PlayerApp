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
        let appRemoteDataSource: AppRemoteDataSource
        let localDataSource: LocalDataSource
    }
    
    private let dependencies: Dependencies
    private let appDelegate: AppDelegate?
    
    init(dependencies: Dependencies, appDelegate: AppDelegate?) {
        self.dependencies = dependencies
        self.appDelegate = appDelegate
    }
    
    
    // MARK: - Use Cases
    
    func makeLaunchUseCase() -> LaunchUseCase {
        return DefaultLaunchUseCase(appRepository: makeAppRepository())
    }
    
    func makeMainUseCase() -> MainUseCase {
        return DefaultMainUseCase(appRepository: makeAppRepository())
    }
    
    
    // MARK: - Repositories
    func makeAppRepository() -> AppRepository {
        return DefaultAppRepository(appRemoteDataSource: dependencies.appRemoteDataSource, localDataSource: dependencies.localDataSource)
    }
    
    
    // MARK: - Launch
    func makeLaunchVC(closures: LaunchVMClosures) -> LaunchVC {
        return LaunchVC.create(with: makeLaunchVM(closures: closures))
    }
    
    func makeLaunchVM(closures: LaunchVMClosures) -> LaunchVM {
        return DefaultLaunchVM(launchUseCase: makeLaunchUseCase(), closures: closures)
    }
    
    // MARK: - Main
    func makeMainVC(closures: MainVMClosures) -> MainVC {
        return MainVC.create(with: makeMainVM(closures: closures))
    }
    
    func makeMainVM(closures: MainVMClosures) -> MainVM {
        return DefaultMainVM(mainUseCase: makeMainUseCase(), closures: closures)
    }
    
    // MARK: - Flow Coordinators
    func makePlayerFlowCoordinator(navigationController: UINavigationController) -> PlayerFlowCoordinator {
        return PlayerFlowCoordinator(navigationController: navigationController, dependencies: self)
    }
}

extension AppSceneDIContainer: PlayerFlowCoordinatorDependencies {
}
