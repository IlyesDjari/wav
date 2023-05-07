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

extension PlayerViewController {
    internal func fetchPlayingSong(songID: String? = nil) {
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
                    // Play the song with the provided songID if it's not already playing
                    if ApplicationMusicPlayer.shared.queue.currentEntry?.item?.id.rawValue != songID {
                        player.queue = [song]
                        try await player.play()
                        await queueRecommendation(songID: songID)
                    }
                } catch {
                    print("Error fetching song details: \(error)")
                }
            }
        } else {
            // Fallback to the original implementation of fetching the now playing song
        }
    }
    
    private func queueRecommendation(songID: String) async {
        do {
            let song = try await MCatalog.song(id: MusicItemID(rawValue: songID))
            let recommendations = try await MRecommendation.continuousSongs(for: song)
            if let recommendedSong = recommendations.first {
                try await player.queue.insert(recommendedSong, position: .afterCurrentEntry)
            }
        } catch {
            print("Error fetching song recommendation: \(error)")
        }
    }

    private func playSong(songID: String) {
        fetchPlayingSong(songID: songID)
        play()
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
