//
//  CoreErrorResponse.swift
//  PlayerApp
//
//  Created by IOS-Cakra on 06/09/26.
//

import Foundation

public enum RequestError: LocalizedError {
//  case requestFailed
//  case requestCanceled
  case errorMessage(message: String)
  case newErrorMessage(message: String)
//  case tokenNotHavePermission
  case invalidToken
  case invalidAccessToken
//  case invalidEmailPassword
  case tokenExpired
  case Unauthorized
//  case resourceNotFound
//  case wrongCode
//  case bundlePathNotFound
  case unknown
  case cloudServicePermissionDenied
  case cloudServiceNetworkConnectionFailed
  case cloudServiceRevoked
  
  public var errorDescription: String? {
    switch self {
//    case .requestFailed: return "msg_error_oss_request_failed".localized()
//    case .requestCanceled: return "msg_error_oss_request_cancel".localized()
    case .errorMessage(let message): return "\(message)"
    case .newErrorMessage(let message): return "\(message)"
//    case .tokenNotHavePermission: return "msg_token_not_have_permission".localized()
    case .invalidToken: return  "The token provided was invalid or expired"
    case .invalidAccessToken: return "Invalid Access Token"
//    case .invalidEmailPassword: return "msg_invalid_email_password".localized()
    case .tokenExpired: return "The token provided was expired"
    case .Unauthorized: return "Unauthorized"
//    case .resourceNotFound: return "msg_resource_not_found".localized()
//    case .wrongCode: return "msg_error_wrong_code".localized()
//    case .bundlePathNotFound: return "msg_bundle_path_not_found".localized()
    case .unknown: return "\(ErrMsgConst.ERROR_FETCH_PRODUCT)#Unknown error. Please contact support"
    case .cloudServicePermissionDenied: return "\(ErrMsgConst.ERROR_FETCH_PRODUCT)#Access to cloud service information is not allowed"
    case .cloudServiceNetworkConnectionFailed: return "\(ErrMsgConst.ERROR_FETCH_PRODUCT)#Could not connect to the network"
    case .cloudServiceRevoked: return "\(ErrMsgConst.ERROR_FETCH_PRODUCT)#User has revoked permission to use this cloud service"
    }
  }
}

public final class ErrMsgConst {
  public static let SESSION_TIME_OUT = 999
  public static let NEED_REFRESH_TOKEN = 401
  public static let DETECT_NEW_DEVICE = 409
  public static let INVALID_LOGIN_CHANNEL = 451
  public static let INACTIVE_ACCOUNT = 410
  public static let BAD_REQUEST = 400
  public static let RESOURCE_NOT_FOUND = 404
  public static let INTERNAL_SERVER_ERROR = 500
  public static let ERROR_FUNCTION = 9999
  public static let ERROR_INFO = 9998
  public static let NETWORK_DISCONNECTED = 9997
  public static let ERROR_FETCH_PRODUCT = 9996
  public static let ERROR_UNVERYFIED = 9995
  public static let DB_INVALID_INSTANCE = "DB1"
  public static let DB_REQUEST_INVALID = "DB2"
  public static let DB_ENTITY_EMPTY = "DB3"
}
