//
//  AudioPlayerService.swift
//  PlayerApp
//
//  Created by IOS-Cakra on 06/09/26.
//

import Foundation
import AVFoundation
import UIKit

public protocol AudioPlayerDelegate: AnyObject {
    func audioPlayerDidUpdateState(isPlaying: Bool)
    func audioPlayerDidUpdateProgress(currentTime: TimeInterval, duration: TimeInterval)
    func audioPlayerDidStartTrack(song: SongModel, index: Int)
    func audioPlayerDidFinishPlaylist()
}

public final class AudioPlayerService: NSObject {
    
    public static let shared = AudioPlayerService()
    
    public weak var delegate: AudioPlayerDelegate?
    
    private var player: AVPlayer?
    private var timeObserverToken: Any?
    
    public private(set) var playlist: [SongModel] = []
    public private(set) var currentIndex: Int = -1
    public private(set) var isPlaying: Bool = false
    
    public var currentSong: SongModel? {
        guard playlist.indices.contains(currentIndex) else { return nil }
        return playlist[currentIndex]
    }
    
    public var currentProgress: Float {
        guard let currentItem = player?.currentItem else { return 0 }
        let duration = currentItem.duration.seconds
        let current = currentItem.currentTime().seconds
        guard duration > 0, !duration.isNaN, !current.isNaN else { return 0 }
        return Float(current / duration)
    }
    
    private override init() {
        super.init()
        setupAudioSession()
    }
    
    deinit {
        removeTimeObserver()
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("AudioSession setup error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Playlist Management
    
    public func setPlaylist(_ songs: [SongModel], startAt index: Int = 0) {
        self.playlist = songs
        if !songs.isEmpty && songs.indices.contains(index) {
            playSong(at: index)
        }
    }
    
    // MARK: - Playback Controls
    
    public func playSong(at index: Int) {
        guard playlist.indices.contains(index) else { return }
        
        self.currentIndex = index
        let song = playlist[index]
        
        guard let url = URL(string: song.previewUrl) else {
            print("Invalid song previewUrl: \(song.previewUrl)")
            return
        }
        
        removeTimeObserver()
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
        
        let playerItem = AVPlayerItem(url: url)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerItemDidPlayToEndTime(_:)),
            name: .AVPlayerItemDidPlayToEndTime,
            object: playerItem
        )
        
        if player == nil {
            player = AVPlayer(playerItem: playerItem)
        } else {
            player?.replaceCurrentItem(with: playerItem)
        }
        
        addTimeObserver()
        player?.play()
        isPlaying = true
        
        delegate?.audioPlayerDidStartTrack(song: song, index: index)
        delegate?.audioPlayerDidUpdateState(isPlaying: true)
    }
    
    public func togglePlayPause() {
        if isPlaying {
            pause()
        } else {
            resume()
        }
    }
    
    public func pause() {
        player?.pause()
        isPlaying = false
        delegate?.audioPlayerDidUpdateState(isPlaying: false)
    }
    
    public func resume() {
        if player == nil || player?.currentItem == nil {
            if playlist.indices.contains(currentIndex) {
                playSong(at: currentIndex)
            } else if !playlist.isEmpty {
                playSong(at: 0)
            }
            return
        }
        player?.play()
        isPlaying = true
        delegate?.audioPlayerDidUpdateState(isPlaying: true)
    }
    
    public func playNext() {
        guard !playlist.isEmpty else { return }
        let nextIndex = currentIndex + 1
        if nextIndex < playlist.count {
            playSong(at: nextIndex)
        } else {
            // Loop back to first song
            playSong(at: 0)
        }
    }
    
    public func playPrevious() {
        guard !playlist.isEmpty else { return }
        // If current song played more than 3 seconds, replay from beginning
        if let currentSeconds = player?.currentTime().seconds, currentSeconds > 3.0 {
            seek(to: 0.0)
            resume()
            return
        }
        
        let prevIndex = currentIndex - 1
        if prevIndex >= 0 {
            playSong(at: prevIndex)
        } else {
            // Loop to last song
            playSong(at: playlist.count - 1)
        }
    }
    
    public func seek(to percentage: Float) {
        guard let currentItem = player?.currentItem else { return }
        let duration = currentItem.duration.seconds
        guard duration > 0, !duration.isNaN else { return }
        
        let targetSeconds = duration * Double(max(0.0, min(1.0, percentage)))
        let targetTime = CMTime(seconds: targetSeconds, preferredTimescale: 600)
        player?.seek(to: targetTime, toleranceBefore: .zero, toleranceAfter: .zero)
    }
    
    // MARK: - Auto Play Next Song
    
    @objc private func playerItemDidPlayToEndTime(_ notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.playNext()
        }
    }
    
    // MARK: - Time Observer
    
    private func addTimeObserver() {
        let interval = CMTime(seconds: 0.25, preferredTimescale: 600)
        timeObserverToken = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self = self, let currentItem = self.player?.currentItem else { return }
            let durationSeconds = currentItem.duration.seconds
            let currentSeconds = time.seconds
            
            let safeDuration = (durationSeconds > 0 && !durationSeconds.isNaN) ? durationSeconds : 30.0
            let safeCurrent = (currentSeconds >= 0 && !currentSeconds.isNaN) ? currentSeconds : 0.0
            
            self.delegate?.audioPlayerDidUpdateProgress(currentTime: safeCurrent, duration: safeDuration)
        }
    }
    
    private func removeTimeObserver() {
        if let token = timeObserverToken {
            player?.removeTimeObserver(token)
            timeObserverToken = nil
        }
    }
}
