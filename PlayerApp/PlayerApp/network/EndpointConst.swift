//
//  EndpointConst.swift
//  PlayerApp
//
//  Created by IOS-Cakra on 06/09/26.
//

public enum EndpointConst {
    case getListSong
    case getTopSongs
    
    public var rawValue: String {
        switch self {
            
            // MARK: GET ENDPOINT
        case .getListSong: return GlobalFunc.getAppEndpoint().EP_SEARCH!
        case .getTopSongs: return GlobalFunc.getAppEndpoint().EP_TOP_SONGS ?? "us/rss/topsongs/limit=50/json"
        }
    }
}
