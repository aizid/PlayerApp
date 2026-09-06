//
//  GlobalFunc.swift
//  PlayerApp
//
//  Created by IOS-Cakra on 06/09/26.
//
import UIKit
import Foundation

class GlobalFunc {
    
    // REGULAR EXPRESSION
    // ===========================================================
    static func MATCH(value: String, pattern: String) -> Bool{
        let range = value.range(of: pattern, options: .regularExpression)
        if range == nil {
            return false
        } else {
            return true
        }
    }
    
    // KEY CHAIN WRAPPER
    // ===========================================================
    static func GET_KEYCHAIN_WRAPPER_STRING(key: String) -> String{
        let retriveData: String? = UserDefaults.standard.string(forKey: key)
        return retriveData ?? ""
    }
    
    static func SET_KEYCHAIN_WRAPPER_STRING(key: String, value: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    static func GET_KEYCHAIN_WRAPPER_INT(key: String) -> Int{
        let retriveData: Int? = UserDefaults.standard.integer(forKey: key)
        return retriveData ?? 0
    }
    
    static func GET_KEYCHAIN_WRAPPER_INT64(key: String) -> Int64{
        let retriveData: Int? = UserDefaults.standard.integer(forKey: key)
        return Int64(retriveData ?? 0)
    }
    
    static func SET_KEYCHAIN_WRAPPER_INT(key: String, value: Int) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    static func SET_KEYCHAIN_WRAPPER_INT64(key: String, value: Int64) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    static func GET_KEYCHAIN_WRAPPER_BOOLEAN(key: String) -> Bool{
        let retriveData: Bool? = UserDefaults.standard.bool(forKey: key)
        return retriveData ?? false
    }
    
    static func SET_KEYCHAIN_WRAPPER_BOOLEAN(key: String, value: Bool) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    static func REMOVE_KEYCHAIN_WRAPPER(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    // ===========================================================
    //DATE FORMATTER
    public static func getCurrentTimeZone() -> String {
      return TimeZone.current.identifier
    }
    
    static func getCurrentDate() -> Date! {
        let currentDate = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.timeZone = TimeZone(identifier: "id") as TimeZone?
        let date = dateFormatter.date(from: dateFormatter.string(from: currentDate as Date))
        return date
    }
    
    static func getCurrentDate() -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale.current
        let dateString = dateFormatter.string(from: currentDate)
        return dateString
    }
    
    static func getDateMinusYears(yearsToSubtract: Int) -> String {
        let calendar = Calendar.current
        if let date = calendar.date(byAdding: .year, value: -yearsToSubtract, to: Date()) {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            formatter.locale = Locale.current
            return formatter.string(from: date)
        } else {
            return ""
        }
    }
    
    static func convertDateFormatType(from dateString: String, inputFormat: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = inputFormat
        inputFormatter.locale = Locale(identifier: "id_ID") // Indonesian locale
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd MMMM yyyy" // ex:01 Agustus 1990
        outputFormatter.locale = Locale(identifier: "id_ID")
        
        if let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        } else {
            return dateString // return original if parsing fails
        }
    }
    
    public static func dateToStringDateFormatter(dateFormat: String, mDate: Date, locale: String? = "en_US") -> String {
      let dateFormatter = dateFormater(format: dateFormat, locale: locale ?? "en_US")
      return dateFormatter.string(from: mDate)
    }
    
    public static func stringToDateFormatter(dateFormat: String, date: String, locale: String? = "en_US", timeZone: TimeZone? = TimeZone(identifier: getCurrentTimeZone())!) -> Date {
        let dateFormatter = dateFormater(format: dateFormat, locale: locale ?? "en_US", timeZone: timeZone)
        return dateFormatter.date(from: date) ?? Date()
    }
    
    public static func dateFormater(format: String? = "MMM d, h:mm a", locale: String, timeZone: TimeZone? = TimeZone(identifier: getCurrentTimeZone())!) -> DateFormatter {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = format
      dateFormatter.timeZone = timeZone
      dateFormatter.locale = Locale(identifier: locale)
      dateFormatter.amSymbol = "AM"
      dateFormatter.pmSymbol = "PM"
      dateFormatter.calendar = Calendar(identifier: .gregorian)
      return dateFormatter
    }
    
    static func parseErrorByPartResponse(_ response: String, needError: String) -> String {
        let parts = response.components(separatedBy: "#")
        let keys: [String: Int] = [
            "errorStat": 0,
            "status": 1,
            "reason": 2,
            "message": 3,
            "titleMessage": 4,
            "detailMessage": 5,
            "api": 6
        ]
        
        if let index = keys[needError], index < parts.count {
            return parts[index]
        } else {
            return response
        }
    }
}

extension Bundle {
    var appVersion: String {
        infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    }

    var buildNumber: String {
        infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
    }

    var ShowAppVersion: String {
        "\(appVersion)"
    }
    
    var ShowBuildNumber: String {
        "\(buildNumber)"
    }
}

extension GlobalFunc {
    // MARK: Version Build Bundle
    // ===========================================================
    //1
    static var appVersionBundle: String {
        guard
            let info = Bundle.main.infoDictionary,
            let version = info["CFBundleShortVersionString"] as? String
            else { return "" }
        return version
    }

    //2
    static var appBuildBundle: String {
        guard
            let info = Bundle.main.infoDictionary,
            let version = info["CFBundleVersion"] as? String
            else { return "" }
        return version
    }
    
    // MARK: App property Accessor
    // ===========================================================
    public static func getAppProperties() -> PropertyModel {
        print(getProperties(propertiesName: "AppProperty", mode: PropertyModel.self))
        if let appProperties = getProperties(propertiesName: "AppProperty", mode: PropertyModel.self) {
            return appProperties
        }
        return PropertyModel()
    }
    
    public static func getAppEndpoint() -> PropertyModel {
        print(getProperties(propertiesName: "AppEndpoint", mode: PropertyModel.self))
        if let appEndpoint = getProperties(propertiesName: "AppEndpoint", mode: PropertyModel.self) {
            return appEndpoint
        }
        return PropertyModel()
    }
    
    public static func getProperties<D: Decodable>(propertiesName: String, mode: D.Type) -> D? {
        if let bundle      = Bundle.main.bundleIdentifier,
           let path        = Bundle.main.path(forResource: propertiesName, ofType: "plist"),
           let xml         = FileManager.default.contents(atPath: path),
           let preferences = try? PropertyListDecoder().decode(D.self, from: xml) {
            return preferences
        }
        return nil
    }
    
    // MARK: JSON Serialization
    // ===========================================================
    public static func rawJson (body: [String: Any]) -> Data {
        let mBody = body as NSDictionary
        do {
            let data = try JSONSerialization.data(withJSONObject: mBody, options: .prettyPrinted)
            let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
            if let json = json { Log.debug(json) }
            return data
        } catch let error {
            Log.debug(error.localizedDescription)
            return Data()
        }
    }
}

//Extension UIView
extension UIView {
    
    func setSquaredTextCustom(radius: Int, brdrColor: String, bgColor: String){
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.init(named: brdrColor)?.cgColor
        self.layer.backgroundColor = UIColor.init(named: bgColor)?.cgColor
        self.layer.cornerRadius = CGFloat(radius)
        self.layoutIfNeeded()
    }
}

