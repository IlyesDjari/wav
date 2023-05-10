//
//  SearchViewController+TableView.swift
//  wav
//
//  Created by Ilyes Djari on 08/05/2023.
//

import Foundation
import UIKit
import MusadoraKit
import Kingfisher

extension SearchViewController: UITableViewDataSource {
    
    
    func searchSong(searchText: String) async {
        do {
            // Search for songs with the given text
            let searchResponse = try await MCatalog.search(for: searchText, types: [.songs], limit: 20)
            // Print the best matching results
            searchResults = searchResponse.songs
            // Reload the table view
            tableView.reloadData()
        } catch {
            print("Error searching for songs: \(error)")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of songs in the search response
        return searchResults.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue the custom cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as? SearchViewCell else {
            fatalError("Unable to dequeue CustomTableViewCell")
        }
        // Get the song at the current index
        let song = searchResults[indexPath.row]
        print(song)
        // Set the labels in the cell
        cell.songLabel.text = song.title
        cell.artistLabel.text = song.artistName
        cell.coverImage.kf.setImage(with: song.artwork?.url(width: 200, height: 200))
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let song = searchResults[indexPath.row]
        let songID = song.id.rawValue
        performSegue(withIdentifier: "searchPlayerSegue", sender: songID)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "searchPlayerSegue",
              let songID = sender as? String else {
            return
        }
        let destinationVC = segue.destination as? PlayerViewController
        destinationVC?.songID = songID
    }
}
