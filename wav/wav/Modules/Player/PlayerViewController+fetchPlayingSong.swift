//
//  PlayerViewController+fetchPlayingSong.swift
//  wav
//
//  Created by Ilyes Djari on 06/05/2023.
//

import Foundation
import UIKit
import MusicKit
import MusadoraKit
import MediaPlayer

extension PlayerViewController {
    internal func fetchPlayingSong(songID: String? = nil) {
        // If playlistIDs is not nil, return early and let the playlist logic handle playback
        if playlistIDs != nil {
            return
        }

        guard let songID = songID else {
            // Fallback to the original implementation of fetching the now playing song
            return
        }
        Task {
            do {
                let song = try await MCatalog.song(id: MusicItemID(rawValue: songID))
                let recommendations = try await MRecommendation.continuousSongs(for: song)
                DispatchQueue.main.async {
                    self.updateUI(with: song)
                }
                if let nowPlayingItem = MPMusicPlayerController.applicationMusicPlayer.nowPlayingItem,
                    nowPlayingItem.playbackStoreID == songID {
                    queueRecommendation(recommendations: recommendations)
                } else {
                    player.queue = [song]
                    try await player.play()
                    queueRecommendation(recommendations: recommendations)
                }
            } catch {
                print("Error fetching song details: \(error)")
            }
        }
    }

    private func updateUI(with song: Song) {
        self.song.text = song.title
        self.artist.text = song.artistName
        if let artworkURL = song.artwork?.url(width: 500, height: 500) {
            self.cover.kf.setImage(
                with: artworkURL,
                placeholder: UIImage(named: "loading_placeholder"),
                options: [.cacheOriginalImage]
            ) { result in
                switch result {
                case .success(let value):
                    let coverImage = value.image
                    self.cover.image = coverImage
                    if let duration = song.duration {
                        self.timeline.maximumValue = Float(duration)
                        let formattedSongTime = formatPlaybackTime(duration)
                        self.songTime.text = formattedSongTime
                    }
                    updateTimelineGradient(from: coverImage, in: self.timeline)
                    updateBackgroundColor(from: coverImage, in: self.background)
                case .failure:
                    break
                }
            }
        }
    }

    internal func queueRecommendation(recommendations: MusicItemCollection<Song>) {
        if let recommendedSong = recommendations.first {
            Task {
                do {
                    try await player.queue.insert(recommendedSong, position: .tail)
                    print(player.queue.entries.count)
                    print(player.queue.entries)
                    print(recommendedSong)
                } catch {
                    print("Error fetching song recommendation: \(error)")
                }
            }
        }
    }

    public func play() {
        Task {
            do {
                try await player.play()
            } catch {
                print("Failed to prepare to play with error: \(error).")
            }
        }
    }
}
