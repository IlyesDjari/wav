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
        let oldImage = stateButton.image
        // Animate the image change with a bounce effect
        let animationDuration = 0.3
        let animationDamping: CGFloat = 0.5
        let animationVelocity: CGFloat = 5.0
        UIView.transition(with: stateButton, duration: animationDuration, options: [.transitionCrossDissolve, .allowAnimatedContent], animations: {
            stateButton.image = newImage
            if oldImage != nil && isPlaying != (oldImage == UIImage(named: "homePause")) {
                stateButton.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }
        }, completion: { _ in
            UIView.animate(withDuration: animationDuration, delay: 0, usingSpringWithDamping: animationDamping, initialSpringVelocity: animationVelocity, options: [], animations: {
                stateButton.transform = .identity
            }, completion: nil)
        })
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
}
