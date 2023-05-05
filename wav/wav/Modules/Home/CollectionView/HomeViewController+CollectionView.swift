//
//  HomeViewController+CollectionView.swift
//  wav
//
//  Created by Ilyes Djari on 05/05/2023.
//

import Foundation
import UIKit


extension HomeViewController {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == HistoryCollectionView {
            // Return the number of recent items
            return recentItems.count
        } else if collectionView == ForYouCollectionView {
            // Return the number of recommended stations
            return recommendedStations.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == HistoryCollectionView {
            // Dequeue a reusable cell and cast it to your custom collection view cell class
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recentItemCell", for: indexPath) as! RecentItemCollectionViewCell
            // Get the corresponding recent item
            let recentItem = recentItems[indexPath.row]
            // Set the song title to the cell label
            if let artworkURL = recentItem.song?.artwork?.url(width: 500, height: 500) {
                cell.cover.kf.setImage(with: artworkURL)
            } else {
                cell.cover.image = nil
            }
            cell.song.text = recentItem.song?.artistName
            cell.artist.text = recentItem.song?.title
            return cell
        } else if collectionView == ForYouCollectionView {
            // Dequeue a reusable cell and cast it to your custom collection view cell class
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "foryouCell", for: indexPath) as! ForYouCollectionViewCell
            // Get the corresponding recommended station
            let recommendedStation = recommendedStations[indexPath.row]
            print(recommendedStation)
            // Set the station name to the cell label
            cell.title.text = recommendedStation.name
            // Set the station image to the cell image view
            if let imageURL = recommendedStation.artwork?.url(width: 500, height: 500) {
                cell.cover.kf.setImage(with: imageURL)
            } else {
                cell.cover.image = nil
            }
            return cell
        } else {
            // Return an empty cell if the collection view is not recognized
            return UICollectionViewCell()
        }
    }
}
