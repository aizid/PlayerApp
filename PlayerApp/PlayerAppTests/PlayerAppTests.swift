import Testing
import Foundation
@testable import PlayerApp

struct PlayerAppTests {

    // MARK: - SearchSongParam Tests
    
    @Test func testSearchSongParamDefaults() {
        let param = SearchSongParam(term: "Coldplay")
        #expect(param.term == "Coldplay")
        #expect(param.media == "music")
        #expect(param.entity == "song")
        #expect(param.attribute == "songTerm")
        #expect(param.limit == 25)
    }
    
    @Test func testSearchSongParamCustom() {
        let param = SearchSongParam(term: "Beatles", media: "music", entity: "song", attribute: "allArtistTerm", limit: 50)
        #expect(param.term == "Beatles")
        #expect(param.limit == 50)
        #expect(param.attribute == "allArtistTerm")
    }

    // MARK: - GeneralMapper Tests
    
    @Test func testGeneralMapperListSongResMapping() {
        let sampleSong = SongRes(
            id: 1001,
            trackName: "Yellow",
            artistName: "Coldplay",
            collectionName: "Parachutes",
            previewUrl: "https://example.com/yellow.m4a",
            artworkUrl100: "https://example.com/art.jpg",
            trackTimeMillis: 269000
        )
        let response = ListSongRes(resultCount: 1, results: [sampleSong])
        let model = GeneralMapper.transListSongResToModel(response: response)
        
        #expect(model.resultCount == 1)
        #expect(model.results.count == 1)
        #expect(model.results[0].id == 1001)
        #expect(model.results[0].trackName == "Yellow")
        #expect(model.results[0].artistName == "Coldplay")
        #expect(model.results[0].collectionName == "Parachutes")
        #expect(model.results[0].previewUrl == "https://example.com/yellow.m4a")
        #expect(model.results[0].artworkUrl100 == "https://example.com/art.jpg")
        #expect(model.results[0].trackTimeMillis == 269000)
    }
    
    @Test func testGeneralMapperListSongResWithNilOptionals() {
        let sampleSong = SongRes(
            id: 1002,
            trackName: "Unknown Song",
            artistName: "Unknown Artist",
            collectionName: nil,
            previewUrl: nil,
            artworkUrl100: nil,
            trackTimeMillis: nil
        )
        let response = ListSongRes(resultCount: 1, results: [sampleSong])
        let model = GeneralMapper.transListSongResToModel(response: response)
        
        #expect(model.results.count == 1)
        #expect(model.results[0].collectionName == "Single / Unknown Album")
        #expect(model.results[0].previewUrl == "")
        #expect(model.results[0].artworkUrl100 == "")
        #expect(model.results[0].trackTimeMillis == 0)
    }
    
    @Test func testGeneralMapperTopSongFeedResMapping() {
        let entryWithPreview = TopSongFeedRes.TopSongEntry(
            name: TopSongFeedRes.LabelContainer(label: "Song A"),
            artist: TopSongFeedRes.LabelContainer(label: "Artist A"),
            collection: TopSongFeedRes.CollectionContainer(name: TopSongFeedRes.LabelContainer(label: "Album A")),
            image: [TopSongFeedRes.ImageItem(label: "https://example.com/artA.jpg")],
            id: TopSongFeedRes.IdContainer(attributes: TopSongFeedRes.IdContainer.IdAttributes(imId: "501")),
            link: [
                TopSongFeedRes.LinkItem(attributes: TopSongFeedRes.LinkItem.LinkAttributes(
                    href: "https://example.com/previewA.m4a",
                    imAssetType: "preview"
                ))
            ]
        )
        
        let entryWithoutPreview = TopSongFeedRes.TopSongEntry(
            name: TopSongFeedRes.LabelContainer(label: "Song B"),
            artist: TopSongFeedRes.LabelContainer(label: "Artist B"),
            collection: nil,
            image: nil,
            id: TopSongFeedRes.IdContainer(attributes: TopSongFeedRes.IdContainer.IdAttributes(imId: "502")),
            link: [
                TopSongFeedRes.LinkItem(attributes: TopSongFeedRes.LinkItem.LinkAttributes(
                    href: "https://music.apple.com/songB",
                    imAssetType: nil
                ))
            ]
        )
        
        let feed = TopSongFeedRes.TopSongFeed(entry: [entryWithPreview, entryWithoutPreview])
        let feedRes = TopSongFeedRes(feed: feed)
        let model = GeneralMapper.transTopSongFeedResToModel(response: feedRes)
        
        // Only entryWithPreview should be mapped since entryWithoutPreview has no audio preview
        #expect(model.resultCount == 1)
        #expect(model.results.count == 1)
        #expect(model.results[0].id == 501)
        #expect(model.results[0].trackName == "Song A")
        #expect(model.results[0].artistName == "Artist A")
        #expect(model.results[0].collectionName == "Album A")
        #expect(model.results[0].previewUrl == "https://example.com/previewA.m4a")
        #expect(model.results[0].artworkUrl100 == "https://example.com/artA.jpg")
    }

    // MARK: - AudioPlayerService Tests
    
    @Test @MainActor func testAudioPlayerPlaylistManagement() {
        let song1 = SongModel(id: 1, trackName: "Track 1", artistName: "Artist 1", collectionName: "Album 1", previewUrl: "https://example.com/1.m4a", artworkUrl100: "", trackTimeMillis: 30000)
        let song2 = SongModel(id: 2, trackName: "Track 2", artistName: "Artist 2", collectionName: "Album 2", previewUrl: "https://example.com/2.m4a", artworkUrl100: "", trackTimeMillis: 30000)
        let song3 = SongModel(id: 3, trackName: "Track 3", artistName: "Artist 3", collectionName: "Album 3", previewUrl: "https://example.com/3.m4a", artworkUrl100: "", trackTimeMillis: 30000)
        
        let service = AudioPlayerService.shared
        service.setPlaylist([song1, song2, song3], startAt: 0)
        
        #expect(service.playlist.count == 3)
        #expect(service.currentIndex == 0)
        #expect(service.currentSong?.id == 1)
        
        // Advance to next
        service.playNext()
        #expect(service.currentIndex == 1)
        #expect(service.currentSong?.id == 2)
        
        // Return to previous
        service.playPrevious()
        #expect(service.currentIndex == 0)
        #expect(service.currentSong?.id == 1)
    }
    
    @Test @MainActor func testAudioPlayerBoundaryConditions() {
        let service = AudioPlayerService.shared
        
        // Test empty playlist
        service.setPlaylist([], startAt: 0)
        #expect(service.playlist.isEmpty)
        #expect(service.currentSong == nil)
        
        // Safe navigation with empty playlist
        service.playNext()
        #expect(service.currentSong == nil)
        
        service.playPrevious()
        #expect(service.currentSong == nil)
    }

    // MARK: - EndpointConst Tests
    
    @Test func testEndpointConstValues() {
        #expect(EndpointConst.getListSong.rawValue == "search")
        #expect(EndpointConst.getTopSongs.rawValue.contains("topsongs"))
    }
}
