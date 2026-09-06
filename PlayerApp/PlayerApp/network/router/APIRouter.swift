//
//  APIRouter.swift
//  PlayerApp
//
//  Created by IOS-Cakra on 06/09/26.
//

import Foundation
import Alamofire

public enum APIRouter: URLRequestConvertible {
    case getListSong(param: Parameters?)
    case getTopSongs
    case getTopSongsWithLimit(limit: Int)
}

extension APIRouter {
    var method: HTTPMethod {
        switch self {
        case .getListSong, .getTopSongs, .getTopSongsWithLimit:
            return .get
        }
    }
}

extension APIRouter {
    var endpoint: String {
        switch self {
        case .getListSong: return EndpointConst.getListSong.rawValue
        case .getTopSongs: return EndpointConst.getTopSongs.rawValue
        case .getTopSongsWithLimit(let limit): return EndpointConst.getTopSongsWithLimit(limit: limit).rawValue
        }
    }
}

extension APIRouter {
  public func asURLRequest() throws -> URLRequest {
    guard let URL_BASE = URL(string: ConstantProp.BASE_URL) else { fatalError("")}
    let targetURL = URL(string: self.endpoint, relativeTo: URL_BASE)?.absoluteURL ?? URL_BASE.appendingPathComponent(self.endpoint)
    
    var mParameters: Parameters?
    switch self {
    case .getListSong(let param):
        mParameters = param
    case .getTopSongs, .getTopSongsWithLimit:
        mParameters = nil
    }
    
    Log.debug("[PARAMETER]: \(mParameters ?? [:])")
    Log.debug(targetURL.absoluteString)
    
    var urlRequest: URLRequest = URLRequest(url: targetURL)
    urlRequest.httpMethod = self.method.rawValue
    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
//    let getToken = GlobalFunc.GET_KEYCHAIN_WRAPPER_STRING(key: Constant.KEY_PREFF_TOKEN)
//    if !getToken.isEmpty {
//      urlRequest.setValue("Bearer " + getToken, forHTTPHeaderField: "Authorization")
//    }
    
    return try URLCustomEncoding.default.encode(urlRequest, with: mParameters)
  }
}
