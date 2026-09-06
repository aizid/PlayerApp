//
//  DefaultAppRepository.swift
//  PlayerApp
//
//  Created by IOS-Cakra on 06/09/26.
//
import Foundation
import RxSwift

public final class DefaultAppRepository: NSObject {
  typealias ConsuleInstance = (AppRemoteDataSource, LocalDataSource) -> DefaultAppRepository
  
  fileprivate let appRemoteDataSource: AppRemoteDataSource
  fileprivate let localDataSource: LocalDataSource
  
  public init(
    appRemoteDataSource: AppRemoteDataSource,
    localDataSource: LocalDataSource) {
      
      self.appRemoteDataSource = appRemoteDataSource
      self.localDataSource = localDataSource
    }
    
    static let shareInstance: ConsuleInstance = { (appRemoteDataSource, localDataSource) in
        return DefaultAppRepository(
            appRemoteDataSource: appRemoteDataSource,
            localDataSource: localDataSource)
    }
}



extension DefaultAppRepository: AppRepository {
    
    func getListSong(request: SearchSongParam) -> Observable<ListSongModel>? {
        return appRemoteDataSource.getListSong(request: request).map {
            GeneralMapper.transListSongResToModel(response: $0)
        }
    }
}
