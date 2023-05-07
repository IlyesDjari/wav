//
//  HomePlayerViewController+FetchCurrentlyPlaying.swift
//  wav
//
//  Created by Ilyes Djari on 06/05/2023.
//

import Foundation
import UIKit
import MusadoraKit
import MusicKit

extension HomeViewController {
    public func fetchCurrentlyPlaying(songID: String?) {
        guard let songID = songID else {
            // No song is selected
            noSongLabel.isHidden = false
            currentSong.text = ""
            currentArtist.text = ""
            currentCover.image = UIImage(named: "NoSongImage")
            homePlayer.isUserInteractionEnabled = false
            return
        }
        Task {
            do {
                let song = try await MCatalog.song(id: MusicItemID(rawValue: songID))
                noSongLabel.isHidden = true
                homePlayer.isUserInteractionEnabled = true
                currentArtist.text = song.title
                currentSong.text = song.artistName
                if let artworkURL = song.artwork?.url(width: 50, height: 50) {
                    currentCover.kf.indicatorType = .activity
                    currentCover.kf.setImage(
                        with: artworkURL,
                        placeholder: UIImage(named: "loading_placeholder"),
                        options: [.cacheOriginalImage]
                    ) { result in
                        switch result {
                        case .success(let value):
                            let artwork = value.image
                            self.currentCover.image = artwork
                            updateBackgroundColor(from: artwork, in: self.homePlayer)
                        case .failure:
                            break
                        }
                    }
                } else {
                    // Show a placeholder image if no artwork is available
                    currentCover.image = UIImage(named: "NoSongImage")
                    updateBackgroundColor(from: nil, in: self.homePlayer)
                }
            } catch {
                print("Error fetching song details: \(error)")
            }
        }
    }
}
