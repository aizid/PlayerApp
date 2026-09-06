//
//  AppDIContainer.swift
//  PlayerApp
//
//  Created by IOS-Cakra on 06/09/26.
//
import Foundation

final class AppDIContainer {
    
    lazy var appConfiguration = AppConfiguration()
    var appDelegate: AppDelegate?
    
    // MARK: - Network
    lazy var appRemoteDataSource: AppRemoteDataSource = {
        return AppRemoteDataSource()
    }()
    lazy var localDataSource: LocalDataSource = {
        return LocalDataSource(realm: appDelegate?.realm)
    }()
    
    // MARK: - DIContainers of scenes
    func makeAppSceneDIContainer() -> AppSceneDIContainer {
        let dependencies = AppSceneDIContainer.Dependencies(appRemoteDataSource: appRemoteDataSource, localDataSource: localDataSource)
        return AppSceneDIContainer(dependencies: dependencies, appDelegate: appDelegate)
    }
}
