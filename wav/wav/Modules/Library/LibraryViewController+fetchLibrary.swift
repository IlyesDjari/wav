//
//  LibraryViewController+fetchLibrary.swift
//  wav
//
//  Created by Ilyes Djari on 10/05/2023.
//

import Foundation
import MusadoraKit
import UIKit

extension LibraryViewController: UICollectionViewDataSource {
    internal func fetchLibrary() {
        activityIndicator.startAnimating()
        Task {
            let library = try await MLibrary.playlists()
            playlists = library
            collectionView.reloadData()
            activityIndicator.stopAnimating()
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playlists.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "libraryCell", for: indexPath) as! LibraryCollectionViewCell
        let playlist = playlists[indexPath.row]
        cell.title.text = playlist.name
        if let artworkURL = playlist.artwork?.url(width: 500, height: 500),
           let imageData = try? Data(contentsOf: artworkURL),
           let image = UIImage(data: imageData) {
               cell.cover.image = image
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let playlist = playlists[indexPath.row]
        Task {
            do {
                let id = try await playlist.catalog.id
                let detailedPlaylist = try await MCatalog.playlist(id: id, fetch: .tracks)
                let tracks = detailedPlaylist.tracks ?? []
                let songIDs = tracks.map { $0.id.rawValue }
                // Instantiate PlayerViewController from storyboard
                let storyboard = UIStoryboard(name: "Player", bundle: nil)
                guard let playerViewController = storyboard.instantiateViewController(withIdentifier: "PlayerViewController") as? PlayerViewController else {
                    return
                }
                // Fetch and play the playlist
                // playerViewController.playlistIDs = songIDs
                // Present PlayerViewController modally
                self.present(playerViewController, animated: true, completion: nil)
            } catch {
                print("Error fetching playlist: \(error)")
            }
        }
    }
}
