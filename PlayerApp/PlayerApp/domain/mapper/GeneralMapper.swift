//
//  GeneralMapper.swift
//  PlayerApp
//
//  Created by IOS-Cakra on 06/09/26.
//

import Foundation

public final class GeneralMapper {
    
    public static func transListSongResToModel(response: ListSongRes) -> ListSongModel {
        autoreleasepool {
            var songItems: [SongModel] = []
            songItems = response.results.map { item in
                SongModel(
                    id: item.id ?? 0,
                    trackName: item.trackName ?? "",
                    artistName: item.artistName ?? "",
                    collectionName: item.collectionName ?? "Single / Unknown Album",
                    previewUrl: item.previewUrl ?? "",
                    artworkUrl100: item.artworkUrl100 ?? "",
                    trackTimeMillis: item.trackTimeMillis ?? 0
                )
            } ?? []
            songItems
            var listSong: ListSongModel = ListSongModel()
            listSong.results = songItems
            listSong.resultCount = response.resultCount ?? 0
            return listSong
        }
    }
    
    public static func transTopSongFeedResToModel(response: TopSongFeedRes) -> ListSongModel {
        autoreleasepool {
            let entries = response.feed.entry ?? []
            let songItems: [SongModel] = entries.compactMap { entry in
                guard let preview = entry.link?.first(where: { $0.attributes?.imAssetType == "preview" })?.attributes?.href,
                      !preview.isEmpty else {
                    return nil
                }
                let artwork = entry.image?.last?.label ?? ""
                let trackIdStr = entry.id?.attributes?.imId ?? "0"
                let trackId = Int(trackIdStr) ?? 0
                return SongModel(
                    id: trackId,
                    trackName: entry.name?.label ?? "Unknown Track",
                    artistName: entry.artist?.label ?? "Unknown Artist",
                    collectionName: entry.collection?.name?.label ?? "Single / Unknown Album",
                    previewUrl: preview,
                    artworkUrl100: artwork,
                    trackTimeMillis: 30000
                )
            }
            var listSong: ListSongModel = ListSongModel()
            listSong.results = songItems
            listSong.resultCount = songItems.count
            return listSong
        }
    }
}

