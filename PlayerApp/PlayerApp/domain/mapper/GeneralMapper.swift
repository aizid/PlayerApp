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
}

