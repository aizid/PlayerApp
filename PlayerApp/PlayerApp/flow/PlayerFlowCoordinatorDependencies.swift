//
//  PlayerFlowCoordinatorDependencies.swift
//  PlayerApp
//
//  Created by IOS-Cakra on 06/09/26.
//

import Foundation
import UIKit

protocol PlayerFlowCoordinatorDependencies  {
    func makeLaunchVC(closures: LaunchVMClosures) -> LaunchVC
    func makeMainVC(closures: MainVMClosures) -> MainVC
}

class PlayerFlowCoordinator {
    
    private weak var navigationController: UINavigationController?
    private let dependencies: PlayerFlowCoordinatorDependencies
    
    init(navigationController: UINavigationController,
         dependencies: PlayerFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        showLaunch()
    }
    
    private func showLaunch() {
        let closures = LaunchVMClosures(showMain: showMain)
        let vc = dependencies.makeLaunchVC(closures: closures)
        navigationController?.pushViewController(vc, animated: false)
        navigationController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    private func showMain() {
        let closures = MainVMClosures()
        let vc = dependencies.makeMainVC(closures: closures)
        navigationController?.pushViewController(vc, animated: true)
        navigationController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
