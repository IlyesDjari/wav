//
//  HomeViewController+CollectionView.swift
//  wav
//
//  Created by Ilyes Djari on 05/05/2023.
//

import Foundation
import UIKit
import MusadoraKit


extension HomeViewController {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == HistoryCollectionView {
            // Get the corresponding recent item
            let recentItem = recentItems[indexPath.row]
            // Get the song ID and store it in songID
            if let songID = recentItem.song?.id.rawValue {
                self.songID = songID
            } else {
                print("Song ID not found")
                return
            }
            // Perform the segue
            performSegue(withIdentifier: "showPlayer", sender: self)
        } else if collectionView == ForYouCollectionView {
            let playlist = recommendedStations[indexPath.row]
            performSegue(withIdentifier: "homeToPlaylistSegue", sender: playlist)
        } else if collectionView == RecommendedArtistCollectionView {
            let artist = fetchedArtists[indexPath.row]
            performSegue(withIdentifier: "showArtist", sender: artist)
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == HistoryCollectionView {
            // Return the number of recent items
            return recentItems.count
        } else if collectionView == ForYouCollectionView {
            // Return the number of recommended stations
            return recommendedStations.count
        } else if collectionView == RecommendedArtistCollectionView {
            // Return the number of recommended artists
            return fetchedArtists.count
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
            // Set the station name to the cell label
            cell.title.text = recommendedStation.name
            // Set the station image to the cell image view
            if let imageURL = recommendedStation.artwork?.url(width: 500, height: 500) {
                cell.cover.kf.setImage(with: imageURL)
            } else {
                cell.cover.image = nil
            }
            return cell
        } else if collectionView == RecommendedArtistCollectionView {
            // Dequeue a reusable cell and cast it to your custom collection view cell class
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recommendedArtistCell", for: indexPath) as! RecommendedArtistCollectionViewCell
            // Get the corresponding recommended station
            let recommendedArtists = fetchedArtists[indexPath.row]
            // Set the station name to the cell label
            cell.title.text = recommendedArtists.name
            // Set the station image to the cell image view
            let artworkURL = recommendedArtists.artwork?.url(width: 200, height: 200)
            if let imageData = try? Data(contentsOf: artworkURL ?? URL(string: "NoCoverImage")!),
                let image = UIImage(data: imageData) {
                cell.cover.image = image
            }
            return cell
        } else {
            // Return an empty cell if the collection view is not recognized
            return UICollectionViewCell()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPlayer" {
            if let playerViewController = segue.destination as? PlayerViewController {
                playerViewController.songID = songID
                playerViewController.playlistSong = nil
                playerViewController.albumSongs = nil
                playerViewController.homeViewController = self
            }
        } else if segue.identifier == "homeToPlaylistSegue" {
            guard let playlistVC = segue.destination as? ListViewController else { return }
            guard let playlist = sender as? Playlist else { return }
            playlistVC.playlist = playlist
        } else if segue.identifier == "homeToAlbumSegue",
            let albumViewController = segue.destination as? AlbumViewController,
            let album = sender as? Album {
            albumViewController.album = album
        } else if segue.identifier == "showArtist",
            let artistViewController = segue.destination as? ArtistViewController,
            let artist = sender as? Artist {
            artistViewController.artist = artist
        }
    }
}
