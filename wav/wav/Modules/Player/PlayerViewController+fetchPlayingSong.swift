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
        if let songID = songID {
            // Fetch song details
            Task {
                do {
                    let song = try await MCatalog.song(id: MusicItemID(rawValue: songID))
                    DispatchQueue.main.async {
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

                    // Check if the song is already playing
                    if let nowPlayingItem = MPMusicPlayerController.applicationMusicPlayer.nowPlayingItem,
                        nowPlayingItem.playbackStoreID == songID {
                        // The song is already playing, add recommendation to the queue
                        Task {
                            queueRecommendation(songID: songID)
                        }
                    } else {
                        // The song is not playing, play it and add recommendation to the queue
                        Task {
                            player.queue = [song]
                            try await player.play()
                            queueRecommendation(songID: songID)
                        }
                    }
                } catch {
                    print("Error fetching song details: \(error)")
                }
            }
        } else {
            // Fallback to the original implementation of fetching the now playing song
        }
    }

    internal func queueRecommendation(songID: String) {
        Task {
            do {
                let song = try await MCatalog.song(id: MusicItemID(rawValue: songID))
                let recommendations = try await MRecommendation.continuousSongs(for: song)
                if let recommendedSong = recommendations.first {
                    try await player.queue.insert(recommendedSong, position: .tail)
                    print(player.queue.entries.count)
                }
            } catch {
                print("Error fetching song recommendation: \(error)")
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
