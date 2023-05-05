//
//  HomePlayer.swift
//  wav
//
//  Created by Ilyes Djari on 04/05/2023.
//

import Foundation
import MediaPlayer
import MarqueeLabel
import Kingfisher
import UIImageColors

extension HomeViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Register observers for now playing item changes and playback state changes
        NotificationCenter.default.addObserver(self, selector: #selector(nowPlayingItemChanged), name: .MPMusicPlayerControllerNowPlayingItemDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playbackStateChanged), name: .MPMusicPlayerControllerPlaybackStateDidChange, object: nil)
        // Begin generating notifications
        MPMusicPlayerController.systemMusicPlayer.beginGeneratingPlaybackNotifications()
        // Fetch the currently playing item
        fetchCurrentlyPlaying()
        // Set the initial state of the state button
        setStateButtonImage()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Remove observers for now playing item changes and playback state changes
        NotificationCenter.default.removeObserver(self, name: .MPMusicPlayerControllerNowPlayingItemDidChange, object: nil)
        NotificationCenter.default.removeObserver(self, name: .MPMusicPlayerControllerPlaybackStateDidChange, object: nil)
        // End generating notifications
        MPMusicPlayerController.systemMusicPlayer.endGeneratingPlaybackNotifications()
    }

    internal func fetchCurrentlyPlaying() {
        let musicPlayer = MPMusicPlayerController.systemMusicPlayer
        if musicPlayer.playbackState == .playing {
            homePlayer.isHidden = false
            if let nowPlayingItem = musicPlayer.nowPlayingItem,
                let songTitle = nowPlayingItem.title,
                let artistName = nowPlayingItem.artist,
                let coverImage = nowPlayingItem.artwork?.image(at: CGSize(width: 50, height: 50)) {
                
                // Update the UI with the song title, artist name, and cover image
                currentSong.text = artistName
                currentArtist.text = songTitle
                currentCover.image = coverImage
                
                // Get the dominant color of the cover image
                coverImage.getColors { [weak self] colors in
                    guard let self = self, let backgroundColor = colors?.background else { return }
                    // Update the background color of the home player view with the dominant color
                    let background = backgroundColor.isLight ? UIColor.black : backgroundColor
                    UIView.animate(withDuration: 1) {
                        self.homePlayer.backgroundColor = background
                    }
                }
            } else {
                print("Now playing: no info found")
            }
        } else {
            homePlayer.isHidden = true
        }
    }


    internal func setStateButtonImage() {
        let musicPlayer = MPMusicPlayerController.systemMusicPlayer
        if musicPlayer.playbackState == .playing {
            stateButton.image = UIImage(named: "homePause")
        } else {
            stateButton.image = UIImage(named: "homePlay")
        }
    }
    
    internal func togglePlayback() {
        let musicPlayer = MPMusicPlayerController.systemMusicPlayer
        if musicPlayer.playbackState == .playing {
            musicPlayer.pause()
        } else {
            musicPlayer.play()
        }
    }


    @objc func nowPlayingItemChanged() {
        fetchCurrentlyPlaying()
        setStateButtonImage()
    }

    @objc func playbackStateChanged() {
        fetchCurrentlyPlaying()
        setStateButtonImage()
    }
}
