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
        let cell = tableView.dequeueReusableCell(withIdentifier: "nearbyUserCell", for: indexPath) as! NearbyUsersTableViewCell
        let userData = usersData[indexPath.row]
        
        Task {
            do {
                let song = try await MCatalog.song(id: MusicItemID(rawValue: userData.songID))
                // Update the UI on the main queue
                DispatchQueue.main.async {
                    //cell.textLabel?.text = userData.username
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
}
