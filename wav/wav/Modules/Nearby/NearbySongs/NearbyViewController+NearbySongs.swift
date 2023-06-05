//
//  NearbyViewController+NearbySongs.swift
//  wav
//
//  Created by Ilyes Djari on 16/05/2023.
//

import Foundation
import MusadoraKit
import UIKit

extension NearbyViewController {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the table view
        return usersData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(
                withIdentifier: "nearbyUserCell",
                for: indexPath) as? NearbyUsersTableViewCell {
            let userData = usersData[indexPath.row]
            Task {
                do {
                    let song = try await MCatalog.song(id: MusicItemID(rawValue: userData.songID))
                    DispatchQueue.main.async {
                        cell.cover.kf.setImage(with: song.artwork?.url(width: 200, height: 200))
                        cell.songName.text = song.title
                        cell.artist.text = song.artistName
                    }
                } catch {
                    print("Error retrieving song: \(error)")
                }
            }
            return cell
        }

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "LiveSharePlayerSegue", sender: usersData[indexPath.row])
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LiveSharePlayerSegue" {
            if let destinationVC = segue.destination as? LiveSessionPlayerViewController,
                let userData = sender as? NearbyUser {
                destinationVC.usersData = userData
            }
        }
    }
}
