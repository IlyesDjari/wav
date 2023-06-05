//
//  ListViewController+tableView.swift
//  wav
//
//  Created by Ilyes Djari on 10/05/2023.
//

import Foundation
import UIKit
import Kingfisher

extension ListViewController {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(
                withIdentifier: "trackCell",
                for: indexPath) as? TracksTableViewCell {
            let track = tracks[indexPath.row]
            cell.songLabel.text = track.title
            cell.artistLabel.text = track.artistName
            let artworkURL = track.artwork?.url(width: 200, height: 200)
            cell.cover.kf.setImage(with: artworkURL)
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            hideLoadingView()
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Instantiate PlayerViewController from storyboard
        let storyboard = UIStoryboard(name: "Player", bundle: nil)
        guard let playerViewController = storyboard.instantiateViewController(
            withIdentifier: "PlayerViewController") as? PlayerViewController else {
            return
        }
        playerViewController.playlistSongSelected = indexPath.row
        playerViewController.playlistSong = tracks
        // Present PlayerViewController modally
        self.present(playerViewController, animated: true, completion: nil)
    }
}
