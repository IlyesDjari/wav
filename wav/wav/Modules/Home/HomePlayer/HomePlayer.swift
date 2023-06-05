//
//  HomePlayer.swift
//  wav
//
//  Created by Ilyes Djari on 04/05/2023.
//

import Foundation
import UIKit
import MusadoraKit
import MarqueeLabel
import MusicKit
import MediaPlayer

extension HomeViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Register observers for selected song ID changes and playback state changes
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(selectedSongIDChanged(_:)),
            name: .songIDChanged,
            object: nil)
        // Fetch the currently playing item or the selected song
        if let songID = songID {
            fetchCurrentlyPlaying(songID: songID)
            print("Now playing the selected song ID: \(songID)")
        } else {
            fetchCurrentlyPlaying(songID: nil)
        }
        // Set the initial state of the state button
        musicPlaybackControl.setStateButtonImage(stateButton: stateButton)
        // Check playback status
        playbackStatusTimer = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(playbackStatusChanged),
            userInfo: nil,
            repeats: true)
        NotificationCenter.default.addObserver(
            forName: .MPMusicPlayerControllerNowPlayingItemDidChange,
            object: nil,
            queue: nil) { _ in
            if let nextSongID = MPMusicPlayerController.applicationMusicPlayer.nowPlayingItem?.playbackStoreID {
                self.songChanged(nextSongID: nextSongID)
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Remove observers for selected song ID changes and playback state changes
        NotificationCenter.default.removeObserver(self, name: .songIDChanged, object: nil)
        // Remove the observer for playback status changes
        playbackStatusTimer?.invalidate()
    }

    @objc public func playbackStatusChanged() {
        fetchCurrentlyPlaying(songID: songID)
        musicPlaybackControl.setStateButtonImage(stateButton: stateButton)
        if let lastPlaybackStatus = lastPlaybackStatus {
            switch lastPlaybackStatus {
            case .playing:
                print("Music is playing")
            case .paused:
                print("Music is paused")
            default:
                print("Other playback status")
            }
        }
    }

    func songChanged(nextSongID: String) {
        songID = nextSongID
        fetchCurrentlyPlaying(songID: nextSongID)
    }

    @objc func selectedSongIDChanged(_ notification: Notification) {
        if let songID = notification.userInfo?["songID"] as? String {
            self.songID = songID
            fetchCurrentlyPlaying(songID: songID)
            musicPlaybackControl.setStateButtonImage(stateButton: stateButton)
        }
    }
}
