//
//  LaunchVM.swift
//  PlayerApp
//
//  Created by IOS-Cakra on 06/09/26.
//
import Foundation
import RxSwift

struct LaunchVMClosures {
    let showMain: () -> Void
}

protocol LaunchVMInput {
    func didShowMain()
}

protocol LaunchVMOutput {
    
    var disposeBag: DisposeBag { get }
    
}

protocol LaunchVM: LaunchVMInput, LaunchVMOutput {}

final class DefaultLaunchVM: LaunchVM {

    private let launchUseCase: LaunchUseCase
    private let closures: LaunchVMClosures?
    internal let disposeBag: DisposeBag
    
    // MARK: - OUTPUT
    
    // MARK: - Init
    init(launchUseCase: LaunchUseCase,
         closures: LaunchVMClosures? = nil) {
        self.disposeBag = DisposeBag()
        self.launchUseCase = launchUseCase
        self.closures = closures
    }
    
}

// MARK: - INPUT. View event methods
extension DefaultLaunchVM {
    
    func didShowMain() {
        closures?.showMain()
    }
    
}
