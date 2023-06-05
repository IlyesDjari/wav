//
//  playSongFromAlbim.swift
//  wav
//
//  Created by Ilyes Djari on 05/06/2023.
//

import Foundation
import MusadoraKit

extension PlayerViewController {
    internal func playSongsFromAlbum(_ albumSongs: MusicItemCollection<Track>) {
        Task {
            let songs = albumSongs.compactMap { track -> Song? in
                if case .song(let song) = track {
                    return song
                }
                return nil
            }

            guard !songs.isEmpty else {
                print("No songs in the album.")
                return
            }

            let startIndex: Int
            if let selected = albumSongSelected, selected < songs.count {
                startIndex = selected
            } else {
                startIndex = 0
            }

            do {
                try await player.play(song: songs[startIndex])
                fetchPlayingSong(songID: songs[startIndex].id.rawValue)
            } catch {
                print("Failed to play song: \(error)")
                return
            }
            let restOfSongs = songs[(startIndex + 1)...] + songs[..<startIndex]
            for song in restOfSongs {
                try await player.queue.insert(song, position: .tail)
            }
        }
    }
}
