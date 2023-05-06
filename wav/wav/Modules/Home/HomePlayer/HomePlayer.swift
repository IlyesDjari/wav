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

extension HomeViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("test")

        // Register observers for now playing item changes, playback state changes, and selected song ID changes
        NotificationCenter.default.addObserver(self, selector: #selector(playbackStateChanged), name: .MPMusicPlayerControllerPlaybackStateDidChange, object: player)
        NotificationCenter.default.addObserver(self, selector: #selector(selectedSongIDChanged(_:)), name: .songIDChanged, object: nil)

        // Fetch the currently playing item or the selected song
        if let songID = songID {
            fetchCurrentlyPlaying(songID: songID)
            print("Now playing the selected song ID: \(songID)")
        } else {
            fetchCurrentlyPlaying(songID: nil)
        }

        // Set the initial state of the state button
        musicPlaybackControl.setStateButtonImage(stateButton: stateButton)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Remove observers for now playing item changes, playback state changes, and selected song ID changes
        NotificationCenter.default.removeObserver(self, name: .MPMusicPlayerControllerPlaybackStateDidChange, object: player)
        NotificationCenter.default.removeObserver(self, name: .songIDChanged, object: nil)
    }

    @objc func playbackStateChanged() {
        fetchCurrentlyPlaying(songID: songID)
        musicPlaybackControl.setStateButtonImage(stateButton: stateButton)
    }

    @objc func selectedSongIDChanged(_ notification: Notification) {
        if let songID = notification.userInfo?["songID"] as? String {
            self.songID = songID
            fetchCurrentlyPlaying(songID: songID)
            musicPlaybackControl.setStateButtonImage(stateButton: stateButton)
            print("Now playing the selected song ID: \(songID)")
        }
    }
}
