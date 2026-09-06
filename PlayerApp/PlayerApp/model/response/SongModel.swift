//
//  SongModel.swift
//  PlayerApp
//
//  Created by IOS-Cakra on 06/09/26.
//

public struct SongModel {
    
    var id: Int
    var trackName: String
    var artistName: String
    var collectionName: String
    var previewUrl: String
    var artworkUrl100: String
    var trackTimeMillis: Int

    init() {
        self.id = 0
        self.trackName = ""
        self.artistName = ""
        self.collectionName = ""
        self.previewUrl = ""
        self.artworkUrl100 = ""
        self.trackTimeMillis = 0
    }

    init(id: Int, trackName: String, artistName: String, collectionName: String, previewUrl: String, artworkUrl100: String, trackTimeMillis: Int) {
        self.id = id
        self.trackName = trackName
        self.artistName = artistName
        self.collectionName = collectionName
        self.previewUrl = previewUrl
        self.artworkUrl100 = artworkUrl100
        self.trackTimeMillis = trackTimeMillis
    }
}


extension SongModel: SongItemInterface {
    
    var idExt: Int? { return id }
    var trackNameExt: String? { return trackName }
    var artistNameExt: String? { return artistName }
    var collectionNameExt: String? { return collectionName }
    var previewUrlExt: String? { return previewUrl }
    var artworkUrl100Ext: String? { return artworkUrl100 }
    var trackTimeMillisExt: Int? { return trackTimeMillis }
}
