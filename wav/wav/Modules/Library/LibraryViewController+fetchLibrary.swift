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
        Task {
            let library = try await MLibrary.playlists()
            playlists = library
            collectionView.reloadData()
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playlists.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "libraryCell", for: indexPath) as! LibraryCollectionViewCell
        let playlist = playlists[indexPath.row]
        cell.title.text = playlist.name
        if let artworkURL = playlist.artwork?.url(width: 170, height: 170),
           let imageData = try? Data(contentsOf: artworkURL),
           let image = UIImage(data: imageData) {
               cell.cover.image = image
        }
        return cell
    }
}
