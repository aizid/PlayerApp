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
            var songItem: [SongModel] = []
            listSongItem = response.results?.map { item in
                SongModel(
                    id: item.id ?? 0,
                    trackName: item.trackName ?? "",
                    artistName: item.artistName ?? "",
                    previewUrl: item.previewUrl ?? "",
                    artworkUrl100: item.artworkUrl100 ?? "",
                    trackTimeMillis: item.trackTimeMillis ?? 0
                )
            } ?? []
            
            var listSong: ListSongModel = ListSongModel()
            song.results = listSongItem
            song.resultCount = response.resultCount ?? ""
            return listSong
        }
    }
}

