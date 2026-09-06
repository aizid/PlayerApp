//
//  MainUseCase.swift
//  PlayerApp
//
//  Created by IOS-Cakra on 06/09/26.
//
import Foundation
import RxSwift

protocol MainUseCase {
    func getListSong(request: SearchSongParam) -> Observable<ListSongModel>?
    func getTopSongs(limit: Int) -> Observable<ListSongModel>?
}

extension MainUseCase {
    func getTopSongs() -> Observable<ListSongModel>? {
        return getTopSongs(limit: 25)
    }
}

final class DefaultMainUseCase: MainUseCase {

    private let appRepository: AppRepository
    
    init(appRepository: AppRepository) {
        self.appRepository = appRepository
    }
    
    func getListSong(request: SearchSongParam) -> Observable<ListSongModel>? {
        return appRepository.getListSong(request: request)
    }

    func getTopSongs(limit: Int) -> Observable<ListSongModel>? {
        return appRepository.getTopSongs(limit: limit)
    }

}
