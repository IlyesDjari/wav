//
//  getSongInfo.swift
//  wav
//
//  Created by Ilyes Djari on 17/05/2023.
//

import Foundation
import MusadoraKit
import UIKit

extension LiveSessionPlayerViewController {
    
    internal func getSongInfo(songID: String) {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                let song = try await MCatalog.song(id: MusicItemID(rawValue: songID))
                if let artworkURL = song.artwork?.url(width: 200, height: 200) {
                    URLSession.shared.dataTask(with: artworkURL) { (data, response, error) in
                        if let data = data, let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                self.playingCover.image = image
                                self.currentSongName.text = song.title
                                self.currentArtist.text = song.artistName
                                if let secondaryColor = song.artwork?.backgroundColor {
                                    self.suggestView.backgroundColor = UIColor(cgColor: secondaryColor)
                                    addShadow(to: self.suggestView)
                                }
                                updateBackgroundColor(from: image, in: self.view)
                            }
                        }
                    }.resume()
                }
            } catch {
                print("Error retrieving song or loading image: \(error)")
            }
        }
    }
    
    internal func setSuggestion(songID: String) {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                let song = try await MCatalog.song(id: MusicItemID(rawValue: songID))
                if let artworkURL = song.artwork?.url(width: 200, height: 200) {
                    URLSession.shared.dataTask(with: artworkURL) { (data, response, error) in
                        if let data = data, let image = UIImage(data: data) {
                            DispatchQueue.main.async { [self] in
                                self.suggestCover.image = image
                                if let userData = self.usersData {
                                    self.suggestLabel.text = "\(userData.username) adored \(song.title) by \(song.artistName)"
                                }
                            }
                        }
                    }.resume()
                }
            } catch {
                print("Error retrieving song or loading image: \(error)")
            }
        }
    }
}
