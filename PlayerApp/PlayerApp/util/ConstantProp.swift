//
//  ConstantProp.swift
//  PlayerApp
//
//  Created by IOS-Cakra on 06/09/26.
//

import Foundation

public enum Environment: String { // 1
    case Dev = "Debug"
    case Prod = "Release"
}

public final class BuildConfiguration { // 2
    public static let shared = BuildConfiguration()
    
    public var environment: Environment
    
    init() {
        let currentConfiguration = Bundle.main.object(forInfoDictionaryKey: "Configuration") as! String
        
        environment = Environment(rawValue: currentConfiguration)!
    }
}

public final class ConstantProp {
    public static let BASE_URL_WA = "https://wa.me/"
    public static let BASE_URL_ITUNES = "https://itunes.apple.com/app/\(ConstantProp.appStoreId)"
    public static let G_AUTH_ENDPOINT = "https://accounts.google.com/o/oauth2/v2/auth"
    public static let G_TOKEN_ENPOINT = "https://www.googleapis.com/oauth2/v4/token"
    public static let G_ISSUER = "https://accounts.google.com"
    
    public static var appStoreId: String {
        return GlobalFunc.getProperties().APP_STORE_ID!
    }
    
    public static var BASE_URL: String {
        switch BuildConfiguration.shared.environment {
        case .Dev:
            return GlobalFunc.getProperties().BASE_URL_DEV!
        case .Prod:
            return GlobalFunc.getProperties().BASE_URL_PROD!
        }
    }
    
//    public static var REALM_VERS: String {
//        switch BuildConfiguration.shared.environment {
//        case .Dev:
//            return GlobalFunc.getProperties().REALM_VERS_DEV!
//        case .Prod:
//            return GlobalFunc.getProperties().REALM_VERS_PROD!
//        }
//    }
}

public enum ConstantRpc {
}

