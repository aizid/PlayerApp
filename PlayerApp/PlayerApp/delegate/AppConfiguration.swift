//
//  AppConfiguration.swift
//  PlayerApp
//
//  Created by IOS-Cakra on 06/09/26.
//

import Foundation

final class AppConfiguration {
    lazy var apiKey: String = {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "ApiKey") as? String else {
            fatalError("ApiKey must not be empty in plist")
        }
        return apiKey
    }()
    lazy var apiBaseURL: String = {
        if GlobalFunc.GET_KEYCHAIN_WRAPPER_BOOLEAN(key: Constant.END_POINT){
            guard let apiBaseURLProd = Bundle.main.object(forInfoDictionaryKey: GlobalFunc.GET_KEYCHAIN_WRAPPER_STRING(key: Constant.API_BASE_URL)) as? String else {
                fatalError("ApiBaseURLProd must not be empty in plist")
            }
            return apiBaseURLProd
        }else {
            guard let apiBaseURL = Bundle.main.object(forInfoDictionaryKey: GlobalFunc.GET_KEYCHAIN_WRAPPER_STRING(key: Constant.API_BASE_URL)) as? String else {
                fatalError("ApiBaseURL must not be empty in plist")
            }
            return apiBaseURL
        }
        
    }()
    lazy var imagesBaseURL: String = {
        guard let imageBaseURL = Bundle.main.object(forInfoDictionaryKey: "ImageBaseURL") as? String else {
            fatalError("ApiBaseURL must not be empty in plist")
        }
        return imageBaseURL
    }()
}
