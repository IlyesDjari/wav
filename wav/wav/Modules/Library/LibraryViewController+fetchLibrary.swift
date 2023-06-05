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
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "libraryCell", for: indexPath) as? LibraryCollectionViewCell {
            let playlist = playlists[indexPath.row]
            cell.title.text = playlist.name
            if let artworkURL = playlist.artwork?.url(width: 500, height: 500),
                let imageData = try? Data(contentsOf: artworkURL),
                let image = UIImage(data: imageData) {
                cell.cover.image = image
            }
            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let playlist = playlists[indexPath.row]

        let storyboard = UIStoryboard(name: "List", bundle: nil)
        guard let playlistViewController = storyboard.instantiateViewController(withIdentifier: "ListViewController") as? ListViewController else {
            return
        }
        playlistViewController.playlist = playlist
        navigationController?.pushViewController(playlistViewController, animated: true)
    }
}
