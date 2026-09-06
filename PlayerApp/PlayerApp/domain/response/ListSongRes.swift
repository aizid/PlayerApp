//
//  ListSongRes.swift
//  PlayerApp
//
//  Created by IOS-Cakra on 06/09/26.
//

import Foundation

public struct ListSongRes: Decodable {
    let resultCount: Int
    let results: [SongRes]
}

public struct SongRes: Decodable {
    let id: Int
    let trackName: String
    let artistName: String
    let previewUrl: String?
    let artworkUrl100: String?
    let trackTimeMillis: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "trackId"
        case trackName
        case artistName
        case previewUrl
        case artworkUrl100
        case trackTimeMillis
    }
}
