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
        if playlistIDs == nil {
            Task {
                do {
                    let song = try await MCatalog.song(id: MusicItemID(rawValue: songID!))
                    DispatchQueue.main.async {
                        self.updateUI(with: song)
                    }
                    let recommendations = try await MRecommendation.continuousSongs(for: song)
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
        } else if playlistIDs != nil {
            if let currentEntry = player.queue.currentEntry, case let .song(song) = currentEntry.item {
                Task {
                    let song = try await MCatalog.song(id: song.id)
                    updateUI(with: song)
                }
            }
        }
    }

    internal func updateUI(with song: Song) {
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
