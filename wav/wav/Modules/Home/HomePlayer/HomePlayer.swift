//
//  HomePlayer.swift
//  wav
//
//  Created by Ilyes Djari on 04/05/2023.
//

import Foundation
import MediaPlayer
import MusadoraKit
import MarqueeLabel
import Kingfisher

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
        guard let nowPlayingItem = MPMusicPlayerController.systemMusicPlayer.nowPlayingItem,
            let songTitle = nowPlayingItem.title,
            let artistName = nowPlayingItem.artist else {
            // No song playing or paused
            currentSong.text = "No song playing"
            currentArtist.text = ""
            currentCover.image = UIImage(named: "NoSongImage")
            return
        }
        // Update the UI with the song title and artist name
        currentSong.text = artistName
        currentArtist.text = songTitle
        if let artwork = nowPlayingItem.value(forProperty: MPMediaItemPropertyArtwork) as? MPMediaItemArtwork,
            let coverImage = artwork.image(at: CGSize(width: 50, height: 50)) {
            // Update the UI with the song's artwork
            currentCover.image = coverImage

            // Update the background color of the home player view with the dominant color of the artwork
            updateBackgroundColor(from: coverImage, in: homePlayer)
        } else {
            let songID = nowPlayingItem.playbackStoreID
            // Show a loading indicator while the image is loading
            currentCover.kf.indicatorType = .activity
            currentCover.kf.setImage(
                with: URL(string: ""),
                placeholder: UIImage(named: "loading_placeholder"),
                options: [.cacheOriginalImage]
            )
            
            Task {
                let songInfo = try await MCatalog.song(id: MusicItemID(rawValue: songID)).artwork?.url(width: 50, height: 50)
                currentCover.kf.setImage(
                    with: songInfo,
                    placeholder: UIImage(named: "loading_placeholder"),
                    options: [.cacheOriginalImage]
                )
            }
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
