//
//  ListSongModel.swift
//  PlayerApp
//
//  Created by IOS-Cakra on 06/09/26.
//

public struct ListSongModel {
    
    var results: [SongModel]
    var resultCount: Int
    
    init(){
        self.results = []
        self.resultCount = 0
    }
    
    init(results: [SongModel], resultCount: Int) {
        self.results = results
        self.resultCount = resultCount
    }
    
}

