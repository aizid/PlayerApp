//
//  SearchSongParam.swift
//  PlayerApp
//
//  Created by IOS-Cakra on 06/09/26.
//

public struct SearchSongParam {
    
    var term: String
    var media: String
    var entity: String
    var attribute: String
    var limit: Int
    
    // to Dictionary
    var asDictionary: [String: Any] {
        return [
            "term": term,
            "media": media,
            "entity": entity,
            "attribute": attribute,
            "limit": limit
        ]
    }
    
    init() {
        self.term = ""
        self.media = ""
        self.entity = ""
        self.attribute = ""
        self.limit = 0
    }
    
    init(term: String,
         media: String = "music",
         entity: String = "song",
         attribute: String = "songTerm",
         limit: Int = 25) {
        self.term = term
        self.media = media
        self.entity = entity
        self.attribute = attribute
        self.limit = limit
    }
    
}
