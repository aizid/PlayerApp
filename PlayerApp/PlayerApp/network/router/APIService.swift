//
//  APIService.swift
//  PlayerApp
//
//  Created by IOS-Cakra on 06/09/26.
//

import Alamofire
import RxSwift
import Foundation

public class APIService {
  
  func executeRequest<T: Decodable>(_ urlRoute: APIRouter, objectResponse: T.Type, completion: @escaping(ResponseResult<T, Error>) -> Void) {
    AF.request(urlRoute)
      .validate()
      .responseData { response in
        let dataResponse = response.data ?? Data()
        let RC = response.error?.responseCode ?? 0
        Log.debug(String(data: dataResponse, encoding: .utf8) ?? "")
        switch response.result {
        case .success(let data):
          do {
            let mResponse = try JSONDecoder().decode(T.self, from: data)
            completion(.Success(mResponse))
          } catch let decodeError {
            completion(.Error(RequestError.errorMessage(message: "\(ErrMsgConst.ERROR_FUNCTION)#\(decodeError.localizedDescription)")))
          }
        case .failure(let error):
          self.mapRequestFailure(
            endpoint: urlRoute.endpoint,
            RC: RC,
            errorResponse: error,
            dataResponse: dataResponse) { result in
              switch result {
              case .Success(()):
                self.executeRequest(urlRoute, objectResponse: T.self, completion: { childResponse in completion(childResponse) })
              case .Error(let finalError): completion(.Error(finalError))
              }
            }
        }
      }
  }
  
/*
  func executeRefreshToken(completion: @escaping(ResponseResult<Void, Error>) -> Void) {
    let urlRoute = APIRouter.postRefreshToken(body: Utility.rawJson(body: ["refresh_token": SkollaPreference.getTokenRefresh()]))
    AF.request(urlRoute)
      .validate()
      .responseDecodable(of:RefreshTokenResponse.self) { response in
        
        switch response.result {
        case .success(let result):
          SkollaPreference.setToken(token: result.token ?? "")
          SkollaPreference.setRefreshToken(tokenRefresh: result.refreshToken ?? "")
          completion(.Success(()))
        case .failure(let error):
          completion(.Error(RequestError.errorMessage(message: "\(ErrMsgConst.SESSION_TIME_OUT)#\(error.localizedDescription)#\(urlRoute.endpoint)")))
        }
      }
  }
 */
  
  func executeRequest(_ urlRoute: APIRouter, completion: @escaping(ResponseResult<Bool, Error>) -> Void) {
    AF.request(urlRoute)
      .validate()
      .responseData { response in
        let dataResponse = response.data ?? Data()
        let RC = response.error?.responseCode ?? 0
        Log.debug(String(data: dataResponse, encoding: .utf8) ?? "")
        
        switch response.result {
        case .success( _): completion(.Success(true))
        case .failure(let error):
          self.mapRequestFailure(endpoint: urlRoute.endpoint, RC: RC, errorResponse: error, dataResponse: dataResponse) { result in
            switch result {
            case .Success(()): self.executeRequest(urlRoute) { childResponse in completion(childResponse) }
            case .Error(let finalError): completion(.Error(finalError))
            }
          }
        }
      }
  }
  
  func obseverRequest<T: Decodable>(urlRoute: APIRouter, objectResponse: T.Type) -> Observable<T> {
    return Observable<T>.create { observe in
      self.executeRequest(urlRoute, objectResponse: T.self) { result in
        switch result {
        case .Success(let response): observe.onNext(response)
        case .Error(let error): observe.onError(error)
        }
        observe.onCompleted()
      }
      return Disposables.create()
    }
  }
}

extension APIService {
  private func mapRequestFailure(
    endpoint: String,
    RC: Int,
    errorResponse: Error,
    dataResponse: Data,
    completion: @escaping(ResponseResult<Void, Error>) -> Void) {
      do {
        let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: dataResponse)
        var errorMessage = errorResponse.message ?? ""
        var errorDescription = errorResponse.description ?? ""
        var needRefressToken = false
        var invalidAccessToken = false
        var mStatus = "\(RC)"
        var mErrorVisible = errorResponse.error ?? ""
        var titleMessage = errorResponse.title ?? ""
        var detailMessage = errorResponse.detail ?? ""
          
          
        if let status = errorResponse.status {
            mStatus =  Int(status.rawValue) != nil ? "" : status.rawValue
        }
        
        if errorMessage.isEmpty {
          errorMessage = errorDescription
        }
        
        if mErrorVisible.isEmpty {
          mErrorVisible = errorMessage
        }
        
        switch errorMessage {
        case RequestError.invalidToken.errorDescription,
          RequestError.tokenExpired.errorDescription,
          RequestError.Unauthorized.errorDescription: needRefressToken = true
        case RequestError.invalidAccessToken.errorDescription: invalidAccessToken = true
        default:
          if mStatus == "\(ErrMsgConst.NEED_REFRESH_TOKEN)" {
            needRefressToken = true
          }
        }
        
        if needRefressToken || invalidAccessToken {
          if needRefressToken {
//            self.executeRefreshToken { result in
//              switch result {
//              case .Success(()): completion(.Success(()))
//              case .Error(let error): completion(.Error(error))
//              }
//            }
          }
          
          if invalidAccessToken {
            completion(.Error(RequestError.errorMessage(message: "\(ErrMsgConst.SESSION_TIME_OUT)#\(mErrorVisible)#\(endpoint)")))
          }
        } else {
            /*
          CrashLog.nonFatal(
            userId: SkollaPreference.getEncrypt(for: PreferKey.idAccountNF.rawValue),
            error: "\(errorResponse.error ?? "") # \(errorMessage)",
            crashErrorCode: Constant.ERROR_DATA_SOURCE,
            responseCode: "\(RC)",
            serviceLink: endpoint)
             */
          
            completion(.Error(RequestError.errorMessage(message: "\(RC)#\(mStatus)#\(mErrorVisible)#\(errorMessage)#\(titleMessage)#\(detailMessage)#\(endpoint)")))
        }
        
      } catch let decodeError {
        Log.debug(decodeError.localizedDescription)
//        CrashLog.nonFatal(crashError: decodeError as NSError, userId: SkollaPreference.getEncrypt(for: PreferKey.idAccountNF.rawValue), serviceLink: endpoint)
//        completion(.Error(RequestError.errorMessage(message: "\(ErrMsgConst.ERROR_FUNCTION)#\(errorResponse.localizedDescription)")))
          completion(.Error(RequestError.errorMessage(message: "Response was not successful")))
      }
    }
}
