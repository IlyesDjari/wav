//
//  MusicPlaybackControl.swift
//  wav
//
//  Created by Ilyes Djari on 06/05/2023.
//

import Foundation
import UIKit
import MusicKit

struct MusicPlaybackControl {

    let musicPlayer = ApplicationMusicPlayer.shared

    public func setStateButtonImage(stateButton: UIImageView) {
        let isPlaying = musicPlayer.state.playbackStatus == .playing
        let newImage = isPlaying ? UIImage(named: "homePause") : UIImage(named: "homePlay")
        if newImage != stateButton.image {
            stateButton.animateImageTransition(to: newImage, withBounce: true)
        }
    }

    public func togglePlayback() {
        let playbackState = musicPlayer.state.playbackStatus
        switch playbackState {
        case .playing:
            musicPlayer.pause()
        default:
            Task {
                do {
                    try await musicPlayer.play()
                } catch {
                    print("Failed to prepare to play with error: \(error).")
                }
            }
        }
    }

    public func skipToNextSong() async {
        do {
            try await musicPlayer.skipToNextEntry()
        } catch {
            // Handle error here
            print("Error skipping to next song: \(error)")
        }
    }
    public func skipToPreviousSong() async {
        if musicPlayer.playbackTime > 3 {
            musicPlayer.restartCurrentEntry()
            return
        }
        do {
            try await musicPlayer.skipToPreviousEntry()
        } catch {
            // Handle error here
            print("Error skipping to previous song: \(error)")
        }
    }
    public func toggleRepeatMode(repeatModeButton: UIImageView) {
        switch musicPlayer.state.repeatMode {
        case .all:
            musicPlayer.state.repeatMode = .one
            let repeatOneImage = UIImage(named: "repeatOnce")
            repeatModeButton.animateImageTransition(to: repeatOneImage, withBounce: true)
        case .one:
            musicPlayer.state.repeatMode = MusicPlayer.RepeatMode.none
            let repeatImage = UIImage(named: "repeat")
            repeatModeButton.animateImageTransition(to: repeatImage, withBounce: true)
        case .none?:
            musicPlayer.state.repeatMode = .all
            let repeatOnImage = UIImage(named: "repeatOn")
            repeatModeButton.animateImageTransition(to: repeatOnImage, withBounce: true)
        case nil:
            musicPlayer.state.repeatMode = .all
            let repeatOnImage = UIImage(named: "repeatOn")
            repeatModeButton.animateImageTransition(to: repeatOnImage, withBounce: true)
        @unknown default:
            break
        }
    }

    public func toggleShuffleMode(shuffleModeButton: UIImageView) {
        switch musicPlayer.state.shuffleMode {
        case .off:
            musicPlayer.state.shuffleMode = .songs
            let shuffleOnImage = UIImage(named: "shuffleOn")
            shuffleModeButton.animateImageTransition(to: shuffleOnImage, withBounce: true)
        case .songs:
            musicPlayer.state.shuffleMode = .off
            let shuffleOffImage = UIImage(named: "shuffleOff")
            shuffleModeButton.animateImageTransition(to: shuffleOffImage, withBounce: true)
        case .none:
            musicPlayer.state.shuffleMode = .songs
            let shuffleOffImage = UIImage(named: "shuffleOff")
            shuffleModeButton.animateImageTransition(to: shuffleOffImage, withBounce: true)
        @unknown default:
            break
        }
    }

    public func setRepeatModeButtonImage(repeatModeButton: UIImageView) {
        switch musicPlayer.state.repeatMode {
        case .all:
            let repeatOnImage = UIImage(named: "repeatOn")
            repeatModeButton.animateImageTransition(to: repeatOnImage, withBounce: true)
        case .one:
            let repeatOneImage = UIImage(named: "repeatOnce")
            repeatModeButton.animateImageTransition(to: repeatOneImage, withBounce: true)
        case .none?:
            let repeatImage = UIImage(named: "repeat")
            repeatModeButton.animateImageTransition(to: repeatImage, withBounce: true)
        default:
            break
        }
    }

    public func setShuffleModeButtonImage(shuffleModeButton: UIImageView) {
        switch musicPlayer.state.shuffleMode {
        case .off:
            let shuffleOffImage = UIImage(named: "shuffleOff")
            shuffleModeButton.animateImageTransition(to: shuffleOffImage, withBounce: true)
        case .songs:
            let shuffleOnImage = UIImage(named: "shuffleOn")
            shuffleModeButton.animateImageTransition(to: shuffleOnImage, withBounce: true)
        case .none:
            let shuffleOffImage = UIImage(named: "shuffleOff")
            shuffleModeButton.animateImageTransition(to: shuffleOffImage, withBounce: true)
        default:
            break
        }
    }
    
    public func setLiveShareSessionButton(liveSessionButton: UIImageView, liveSessionLabel: UILabel, sharePlayStatus: Bool) {
        if sharePlayStatus {
            // Perform actions when sharePlayStatus is true
            let button = UIImage(named: "liveShareOn")
            liveSessionButton.animateImageTransition(to: button, withBounce: true)
            liveSessionLabel.textColor = UIColor(named: "Purple")
        } else {
            // Perform actions when sharePlayStatus is false
            let button = UIImage(named: "liveShare")
            liveSessionButton.animateImageTransition(to: button, withBounce: true)
            liveSessionLabel.textColor = .white

        }
    }
}
