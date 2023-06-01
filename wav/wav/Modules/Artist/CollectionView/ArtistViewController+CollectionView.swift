//
//  ArtistViewController+CollectionView.swift
//  wav
//
//  Created by Ilyes Djari on 01/06/2023.
//

import Foundation
import MusadoraKit
import UIKit
import Kingfisher
import MarqueeLabel

extension ArtistViewController {


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == topCollectionView {
            return 4
        } else {
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == topCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topSongCell", for: indexPath) as! TopsSongsCollectionViewCell
            cell.cover.kf.setImage(with: artistData?.topSongs?[indexPath.row].artwork?.url(width: 200, height: 200))
            cell.songName.text = artistData?.topSongs?[indexPath.row].title
            cell.artistName.text = artistData?.topSongs?[indexPath.row].artistName
            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == topCollectionView {
            if let songID = artistData?.topSongs?[indexPath.row].id.rawValue {
                performSegue(withIdentifier: "playSong", sender: songID)
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "playSong" {
            if let songID = sender as? String,
                let playerViewController = segue.destination as? PlayerViewController {
                playerViewController.songID = songID
            }
        }
    }

}
