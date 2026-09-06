//
//  EndpointConst.swift
//  PlayerApp
//
//  Created by IOS-Cakra on 06/09/26.
//

public enum EndpointConst {
    case getListSong
    case getTopSongs
    case getTopSongsWithLimit(limit: Int)
    
    public var rawValue: String {
        switch self {
            
            // MARK: GET ENDPOINT
        case .getListSong: return GlobalFunc.getAppEndpoint().EP_SEARCH!
        case .getTopSongs: return GlobalFunc.getAppEndpoint().EP_TOP_SONGS ?? "us/rss/topsongs/limit=25/json"
        case .getTopSongsWithLimit(let limit): return "us/rss/topsongs/limit=\(limit)/json"
        }
    }
}
