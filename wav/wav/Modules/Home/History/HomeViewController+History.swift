//
//  HomeViewController+History.swift
//  wav
//
//  Created by Ilyes Djari on 03/05/2023.
//

import Foundation
import UIKit
import Kingfisher

extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Return the number of recent items
        return recentItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Dequeue a reusable cell and cast it to your custom collection view cell class
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recentItemCell", for: indexPath) as! RecentItemCollectionViewCell
        // Get the corresponding recent item
        let recentItem = recentItems[indexPath.row]
        // Set the song title to the cell label
        if let artworkURL = recentItem.song?.artwork?.url(width: 160, height: 160) {
            cell.cover.kf.setImage(with: artworkURL)
        } else {
            cell.cover.image = nil
        }
        cell.artist.text = recentItem.song?.artistName
        cell.song.text = recentItem.song?.title
        return cell
    }
}
