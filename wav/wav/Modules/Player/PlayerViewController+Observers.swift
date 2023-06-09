//
//  PlayerViewController+Observers.swift
//  wav
//
//  Created by Ilyes Djari on 06/05/2023.
//

import Foundation
import UIKit
import MusicKit
import MediaPlayer

extension PlayerViewController {

    func songChanged(nextSongID: String) {
        debouncedSongChanged()
    }

    internal func performSongChanged() {
        guard let nextSongID = MPMusicPlayerController.applicationMusicPlayer.nowPlayingItem?.playbackStoreID else {
            return
        }
        if nextSongID != self.lastPlayedSongID {
            self.lastPlayedSongID = nextSongID
            self.songID = nextSongID
        }
    }

    @objc func playbackStatusChanged() {
        musicPlaybackControl.setStateButtonImage(stateButton: stateButton)
    }

    @objc internal func timelineValueChanged(_ sender: UISlider) {
        if !timelineEditing {
            player.playbackTime = TimeInterval(sender.value)
            currentTime.text = formatPlaybackTime(player.playbackTime)
        }
    }

    @objc internal func timelineEditingBegan(_ sender: UISlider) {
        timelineEditing = true
    }

    @objc internal func timelineEditingEnded(_ sender: UISlider) {
        timelineEditing = false
        player.playbackTime = TimeInterval(sender.value)
    }

    @objc internal func updatePlaybackTime() {
        if !timelineEditing {
            let playbackTime = player.playbackTime
            let formattedPlaybackTime = formatPlaybackTime(playbackTime)
            currentTime.text = formattedPlaybackTime
            timeline.value = Float(playbackTime)
        }
    }
}
