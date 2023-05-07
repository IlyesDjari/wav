//
//  PlayerViewController+Observers.swift
//  wav
//
//  Created by Ilyes Djari on 06/05/2023.
//

import Foundation
import  UIKit
import MusicKit

extension PlayerViewController {
    
    @objc  func playbackStatusChanged() {
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
    
    @objc func selectedSongIDChanged(_ notification: Notification) {
        if let songID = notification.userInfo?["songID"] as? String {
            self.songID = songID
            fetchPlayingSong(songID: songID)
            musicPlaybackControl.setStateButtonImage(stateButton: stateButton)
            print("Now playing the selected song ID: \(songID)")
        }
    }
    
    @objc func timelineValueChanged(_ sender: UISlider) {
        if !timelineEditing {
            player.playbackTime = TimeInterval(sender.value)
            currentTime.text = formatPlaybackTime(player.playbackTime)
        }
    }

    @objc func timelineEditingBegan(_ sender: UISlider) {
        timelineEditing = true
    }

    @objc func timelineEditingEnded(_ sender: UISlider) {
        timelineEditing = false
        player.playbackTime = TimeInterval(sender.value)
    }

    @objc func updatePlaybackTime() {
        if !timelineEditing {
            let playbackTime = player.playbackTime
            let formattedPlaybackTime = formatPlaybackTime(playbackTime)
            currentTime.text = formattedPlaybackTime
            timeline.value = Float(playbackTime)
        }
    }
}
