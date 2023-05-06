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
    
    func setStateButtonImage(stateButton: UIImageView) {
        DispatchQueue.main.async {
            if musicPlayer.isPlaying {
                stateButton.image = UIImage(named: "homePause")
            } else {
                stateButton.image = UIImage(named: "homePlay")
            }
        }
    }

    func togglePlayback() {
        if musicPlayer.isPlaying {
            musicPlayer.pause()
        } else {
            Task {
                do {
                    try await musicPlayer.play()
                } catch {
                    print("Failed to prepare to play with error: \(error).")
                }
            }
        }
    }
}
