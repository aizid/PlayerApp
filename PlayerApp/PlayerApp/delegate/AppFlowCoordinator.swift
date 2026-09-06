//
//  AppFlowCoordinator.swift
//  PlayerApp
//
//  Created by IOS-Cakra on 06/09/26.
//

import Foundation
import UIKit

class AppFlowCoordinator {

    var navigationController: UINavigationController
    private let appDIContainer: AppDIContainer
    
    init(navigationController: UINavigationController,
         appDIContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }

    func start() {
        let dapenBunSceneDIContainer = appDIContainer.makeDapenbunSceneDIContainer()
        let flow = dapenBunSceneDIContainer.makeDapenbunFlowCoordinator(navigationController: navigationController)
        flow.start()
    }
}
