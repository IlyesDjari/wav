//
//  PlayerViewController+fetchPlayingPlaylist.swift
//  wav
//
//  Created by Ilyes Djari on 11/05/2023.
//

import Foundation
import MusadoraKit


extension PlayerViewController {
    internal func fetchPlayingPlaylist(songIDs: [String]) {
        Task {
            do {
                let songItems = try await MCatalog.songs(ids: songIDs.map { MusicItemID(rawValue: $0) })
                // Insert songs into the queue
                for (_, song) in songItems.enumerated() {
                    try await player.queue.insert(song, position: .tail)
                }
                
                // Play the first song in the playlist
                if let firstEntry = player.queue.entries.first {
                    player.queue.currentEntry = firstEntry
                }
                
                try await player.play()
            } catch {
                print("Error fetching and playing the playlist: \(error)")
            }
        }
    }
}
