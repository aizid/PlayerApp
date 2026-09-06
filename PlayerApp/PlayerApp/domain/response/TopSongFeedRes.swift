//
//  TopSongFeedRes.swift
//  PlayerApp
//
//  Created by IOS-Cakra on 06/09/26.
//

import Foundation

public struct TopSongFeedRes: Decodable {
    public let feed: TopSongFeed
    
    public struct TopSongFeed: Decodable {
        public let entry: [TopSongEntry]?
    }
    
    public struct TopSongEntry: Decodable {
        public let name: LabelContainer?
        public let artist: LabelContainer?
        public let collection: CollectionContainer?
        public let image: [ImageItem]?
        public let id: IdContainer?
        public let link: [LinkItem]?
        
        enum CodingKeys: String, CodingKey {
            case name = "im:name"
            case artist = "im:artist"
            case collection = "im:collection"
            case image = "im:image"
            case id
            case link
        }
    }
    
    public struct LabelContainer: Decodable {
        public let label: String?
    }
    
    public struct CollectionContainer: Decodable {
        public let name: LabelContainer?
        enum CodingKeys: String, CodingKey {
            case name = "im:name"
        }
    }
    
    public struct ImageItem: Decodable {
        public let label: String?
    }
    
    public struct IdContainer: Decodable {
        public let attributes: IdAttributes?
        
        public struct IdAttributes: Decodable {
            public let imId: String?
            enum CodingKeys: String, CodingKey {
                case imId = "im:id"
            }
        }
    }
    
    public struct LinkItem: Decodable {
        public let attributes: LinkAttributes?
        
        public struct LinkAttributes: Decodable {
            public let href: String?
            public let imAssetType: String?
            
            enum CodingKeys: String, CodingKey {
                case href
                case imAssetType = "im:assetType"
            }
        }
    }
}
