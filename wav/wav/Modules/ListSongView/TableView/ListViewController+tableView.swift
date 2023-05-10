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
        let cell = tableView.dequeueReusableCell(withIdentifier: "trackCell", for: indexPath) as! TracksTableViewCell
        let track = tracks[indexPath.row]
        cell.songLabel.text = track.title
        cell.artistLabel.text = track.artistName
        let artworkURL = track.artwork?.url(width: 200, height: 200)
        cell.cover.kf.setImage(with: artworkURL)
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
}
