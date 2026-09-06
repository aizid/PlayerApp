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
        return GlobalFunc.getAppProperties().APP_STORE_ID!
    }
    
    public static var BASE_URL: String {
        return GlobalFunc.getAppProperties().BASE_URL!
    }
    
    public static var REALM_VERS: String {
        return GlobalFunc.getAppProperties().REALM_VERS!
    }
}

public final class ConstantKey {
    //LAYOUT
    public static let KEY_LAYOUT_MAIN = "Main"
    public static let KEY_LAYOUT_LAUNCH = "Launch"
    
    //DATE FORMATTER
    public static let DF_FULL_DATE_TIME_STRIP = "yyyy-MM-dd HH:mm:ss"
    public static let DF_FULL_DATE_TIME_STRIP_T_ZONE = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    public static let DF_FULL_DATE_TIME_SLICE = "yyyy/MM/dd HH:mm:ss"
    public static let DF_FULL_DATE_HALFTIME_STRIP = "yyyy-MM-dd HH:mm"
    public static let DF_FULL_DATE_HALFTIME_SPASE = "dd MMM yyyy, HH:mm"
    public static let DF_FULL_DATE_TIME_ZONE_STRIP = "yyyy-MM-dd HH:mm:ss Z"
    public static let DF_FULL_DATE_TIME_ZONE_DAY = "E, d MMM yyyy HH:mm:ss Z"
    public static let DF_HALFTIME_COLON = "HH:mm"
    public static let DF_HALFDATE_COMMA = "dd MMM, yyyy"
    public static let DF_HALFDATE_STRIP = "yyyy-MM-dd"
    public static let DF_REVERSE_HALFDATE_STRIP = "dd-MM-yyyy"
    public static let DF_HALFDATE_SLICE = "dd/MM/yyyy"
    public static let DF_REVERSE_HALFDATE_SLICE = "yyyy/MM/dd"
    public static let DF_HALFDATE_NOT_SPASE = "yyyyMMdd"
    public static let DF_HALFDATE_FM_SPACE = "dd MMMM yyyy"
    public static let DF_HALFDATE_MY_SPACE = "MMMM yyyy"
    public static let DF_HALFMONTH_MY_SPACE = "MMM yyyy"
    public static let DF_HALFDATE_SPACE = "dd MMM yyyy"
    public static let DF_HALFDATE_SPACE_STRIP = "dd-MMM-yyyy"
    public static let DF_MIDTRANS_EXP_TIME = "dd MMM yyyy, HH:mm"
    public static let DF_HISTORY_CONSULE_TIME = "dd MMM, yyyy HH:mm"
    public static let DF_NF_EXP_TIME = "d MMM, yyyy"
    public static let DF_DAY_NAME = "eee"
    public static let DF_MONTH_NAME = "MMMM"
    public static let DF_YEAR_NAME = "yyyy"
    public static let DF_DAY = "d"
    public static let DF_SORT_DATE = "yyyyMMddHHmmss"
    public static let DF_FULL_TIME_COLON = "HH:mm:ss"
}

