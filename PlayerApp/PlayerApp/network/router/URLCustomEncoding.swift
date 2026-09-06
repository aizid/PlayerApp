//
//  URLCustomEncoding.swift
//  PlayerApp
//
//  Created by IOS-Cakra on 06/09/26.
//

import Foundation
import Alamofire

struct URLCustomEncoding: ParameterEncoding {
    //"Allow Encoding comma allowed"
    static let `default` = URLCustomEncoding()
    
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        
        guard let parameters = parameters else { return request }
        
        if let url = request.url, var components = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            var allowed = CharacterSet.urlQueryAllowed
            allowed.insert(charactersIn: ",") // allow comma
            
            let query = parameters.map { key, value -> String in
                let encodedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: allowed) ?? ""
                let encodedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: allowed) ?? ""
                return "\(encodedKey)=\(encodedValue)"
            }
            .joined(separator: "&")
            
            components.percentEncodedQuery = nil
            components.query = query
            request.url = components.url
        }
        
        return request
    }
}
