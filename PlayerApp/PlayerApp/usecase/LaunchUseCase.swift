//
//  LaunchUseCase.swift
//  PlayerApp
//
//  Created by IOS-Cakra on 06/09/26.
//
import Foundation
import RxSwift

protocol LaunchUseCase {
}

final class DefaultLaunchUseCase: LaunchUseCase {

    private let appRepository: AppRepository
    
    init(appRepository: AppRepository) {
        self.appRepository = appRepository
    }

}
