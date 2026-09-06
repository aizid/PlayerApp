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
    func getTopSongs() -> Observable<ListSongModel>?
}

final class DefaultMainUseCase: MainUseCase {

    private let appRepository: AppRepository
    
    init(appRepository: AppRepository) {
        self.appRepository = appRepository
    }
    
    func getListSong(request: SearchSongParam) -> Observable<ListSongModel>? {
        return appRepository.getListSong(request: request)
    }

    func getTopSongs() -> Observable<ListSongModel>? {
        return appRepository.getTopSongs()
    }

}
