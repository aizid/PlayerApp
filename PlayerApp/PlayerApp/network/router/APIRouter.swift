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
}

extension APIRouter {
    var method: HTTPMethod {
        switch self {
        case .getListSong
            : return .get
        }
    }
}

extension APIRouter {
    var endpoint: String {
        switch self {
        case .getListSong: return EndpointConst.getListSong.rawValue
        }
    }
}

extension APIRouter {
  public func asURLRequest() throws -> URLRequest {
    guard let URL_BASE = URL(string: ConstantProp.BASE_URL) else { fatalError("")}
    var URL = URL_BASE.appendingPathComponent(self.endpoint)
    switch self {
    case .getNews: URL = URL_BASE.appendingPathComponent(self.endpoint)
    default: break
    }
    var mBody: Data?
    var mParameters: Parameters?
    switch self {
    case .getListSong(let param)
        : mParameters = param
      
    default: break
    }
    
    Log.debug("[PARAMETER]: \(mParameters ?? [:])")
    Log.debug(URL.absoluteString)
    
    var urlRequest: URLRequest = URLRequest(url: URL)
    urlRequest.httpMethod = self.method.rawValue
    urlRequest.httpBody = mBody
    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    let getToken = GlobalFunc.GET_KEYCHAIN_WRAPPER_STRING(key: Constant.KEY_PREFF_TOKEN)
    if !getToken.isEmpty {
      urlRequest.setValue("Bearer " + getToken, forHTTPHeaderField: "Authorization")
    }
    
    return try URLCustomEncoding.default.encode(urlRequest, with: mParameters)
  }
}
