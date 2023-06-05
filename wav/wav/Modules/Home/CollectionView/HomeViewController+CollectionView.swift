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
        if collectionView == historyCollectionView {
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
        } else if collectionView == forYouCollectionView {
            let playlist = recommendedStations[indexPath.row]
            performSegue(withIdentifier: "homeToPlaylistSegue", sender: playlist)
        } else if collectionView == recommendedArtistCollectionView {
            let artist = fetchedArtists[indexPath.row]
            performSegue(withIdentifier: "showArtist", sender: artist)
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == historyCollectionView {
            // Return the number of recent items
            return recentItems.count
        } else if collectionView == forYouCollectionView {
            // Return the number of recommended stations
            return recommendedStations.count
        } else if collectionView == recommendedArtistCollectionView {
            // Return the number of recommended artists
            return fetchedArtists.count
        } else {
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == historyCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recentItemCell", for: indexPath) as? RecentItemCollectionViewCell {
                let recentItem = recentItems[indexPath.row]
                if let artworkURL = recentItem.song?.artwork?.url(width: 500, height: 500) {
                    cell.cover.kf.setImage(with: artworkURL)
                } else {
                    cell.cover.image = nil
                }
                cell.song.text = recentItem.song?.artistName
                cell.artist.text = recentItem.song?.title
                return cell
            }
        } else if collectionView == forYouCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "foryouCell", for: indexPath) as? ForYouCollectionViewCell {
                let recommendedStation = recommendedStations[indexPath.row]
                cell.title.text = recommendedStation.name
                if let imageURL = recommendedStation.artwork?.url(width: 500, height: 500) {
                    cell.cover.kf.setImage(with: imageURL)
                } else {
                    cell.cover.image = nil
                }
                return cell
            }
        } else if collectionView == recommendedArtistCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recommendedArtistCell", for: indexPath) as? RecommendedArtistCollectionViewCell {
                let recommendedArtists = fetchedArtists[indexPath.row]
                cell.title.text = recommendedArtists.name
                let artworkURL = recommendedArtists.artwork?.url(width: 200, height: 200)
                if let imageData = try? Data(contentsOf: artworkURL ?? URL(string: "NoCoverImage")!),
                    let image = UIImage(data: imageData) {
                    cell.cover.image = image
                }
                return cell
            }
        }
        return UICollectionViewCell()
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
