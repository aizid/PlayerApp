//
//  AppRepository.swift
//  PlayerApp
//
//  Created by IOS-Cakra on 06/09/26.
//
import Foundation
import RxSwift

protocol AppRepository {
    
    @discardableResult
    func getListSong(request: SearchSongParam) -> Observable<ListSongModel>?
    
}
