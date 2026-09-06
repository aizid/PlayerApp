//
//  GenericResult.swift
//  PlayerApp
//
//  Created by IOS-Cakra on 06/09/26.
//

import Foundation

let GeneralErrorCode = -1

public struct ApiErrorParser {
    static func parse(_ data: Data?) -> ApiError {
        if let dataError = data {
            do {
                return try JSONDecoder().decode(ApiError.self, from: dataError)
            } catch {
                return .responseParseError
            }
        }
        return .unhandledError
    }
}

public struct ApiError : Codable {
    var status: Int
    var message: String?
    var error: String?
    
    static let connectionTimeout = ApiError(status: 1000, message: "ConnectionTimeout", error: nil)
    static let unhandledError = ApiError(status: -9999, message: "UnhandledError", error: nil)
    static let responseParseError = ApiError(status: 2000, message: "ResponseParseError", error: nil)
    static let errorUnAuthorized = ApiError(status: 401, message: "Not Authorized.", error: nil)
}

public enum ApiResult<Value> {
    case success(Value)
    case error(ApiError)
}
