//
//  PropertyModel.swift
//  PlayerApp
//
//  Created by IOS-Cakra on 06/09/26.
//

import Foundation

public struct PropertyModel: Codable {
    public var BASE_URL_DEV: String?
    public var BASE_URL_PROD: String?
    
    public var BASE_APP_URL_DEV: String?
    public var BASE_APP_URL_PROD: String?
    
    public var BASE_REDIRECT_URI_DEV: String?
    public var BASE_REDIRECT_URI_PROD: String?
    
    public var ENCRYPTED_KEY: String?
    public var APP_PRIVACY: String?
    public var APP_VERSION: String?
    public var APP_DEV_VERSION: String?
    public var APP_STORE_ID_DEV: String?
    public var APP_STORE_ID: String?
    public var REALM_VERS_PROD: String?
    public var REALM_VERS_DEV: String?
    public var LOG_ENABLED: String?
    
    //MARK: Post
    public var EP_ACCOUNT_LOGIN: String?
    public var EP_ACCOUNT_LOGOUT: String?
    
    //MARK: Put
    public var EP_CHANGE_IMAGE_GATEWAY: String?
    
    //MARK: Get
    public var EP_VISITOR: String?
    public var EP_PESERTA: String?
}


public struct ConfigHttpError {
    public let htttpError: [ConfigHttpErrorModel]
    
    public init(htttpError: [ConfigHttpErrorModel] = []) {
        self.htttpError = htttpError
    }
    
}

public struct ConfigHttpErrorModel {
    public let id: Int
    public let codeResponse: Int
    public let reasonResponse: String
    public let descriptionResponse: String
    public let imageUrl: String
    public let title: String
    
    public init(id: Int = 0, codeResponse: Int = 0, reasonResponse: String = "", descriptionResponse: String = "", imageUrl: String = "", title: String = "") {
        self.id = id
        self.codeResponse = codeResponse
        self.reasonResponse = reasonResponse
        self.descriptionResponse = descriptionResponse
        self.imageUrl = imageUrl
        self.title = title
    }
    
}

