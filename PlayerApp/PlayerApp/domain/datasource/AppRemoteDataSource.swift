//
//  AppRemoteDataSource.swift
//  PlayerApp
//
//  Created by IOS-Cakra on 06/09/26.
//

import Foundation
import RxSwift
import Alamofire

public final class AppRemoteDataSource: NSObject {
    public override init() {}
    
    static let shareInstance: AppRemoteDataSource = AppRemoteDataSource()
}

extension AppRemoteDataSource {
    
    public func getListSong(request: SearchSongParam) -> Observable<ListSongRes> {
        let param: Parameters = [
            "term": request.term,
            "media": request.media,
            "entity": request.entity,
            "attribute": request.attribute,
            "limit": request.limit
        ]
        return APIService().obseverRequest(urlRoute: APIRouter.getListSong(param: param), objectResponse: ListSongRes.self)
    }
}

