//
//  AlbumViewController+TableView.swift
//  wav
//
//  Created by Ilyes Djari on 26/05/2023.
//

import Foundation
import UIKit
import MarqueeLabel

extension AlbumViewController {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "albumTrackCell", for: indexPath) as! AlbumTracksTableViewCell
        let track = tracks[indexPath.row]
        cell.songNumber.text = "\(indexPath.row + 1)."
        cell.songTitle.text = track.title
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Instantiate PlayerViewController from storyboard
        let storyboard = UIStoryboard(name: "Player", bundle: nil)
        guard let playerViewController = storyboard.instantiateViewController(withIdentifier: "PlayerViewController") as? PlayerViewController else {
            return
        }
        playerViewController.albumSongSelected = indexPath.row
        playerViewController.albumSongs = tracks
        // Present PlayerViewController modally
        self.present(playerViewController, animated: true, completion: nil)
    }
}
