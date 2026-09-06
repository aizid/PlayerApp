//
//  EndpointConst.swift
//  PlayerApp
//
//  Created by IOS-Cakra on 06/09/26.
//

public enum EndpointConst {
    case getListSong
    
    public var rawValue: String {
        switch self {
            
            // MARK: GET ENDPOINT
        case .getListSong: return GlobalFunc.getAppEndpoint().EP_SEARCH!
        }
    }
}
