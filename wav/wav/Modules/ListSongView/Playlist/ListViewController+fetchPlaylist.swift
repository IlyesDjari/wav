//
//  ListViewController+fetchPlaylist.swift
//  wav
//
//  Created by Ilyes Djari on 10/05/2023.
//

import Foundation
import UIKit
import MusadoraKit


extension ListViewController {
    internal func fetchPlaylist(_ playlist: Playlist) {
        Task {
            do {
                let detailedPlaylist = try await MCatalog.playlist(id: playlist.id, fetch: .tracks)
                tracks = detailedPlaylist.tracks ?? []
            } catch {
                print("Failed to fetch playlist using MCatalog: \(error)")
                fetchPlaylistFromLibrary(playlist)
            }
        }
    }

    private func fetchPlaylistFromLibrary(_ playlist: Playlist) {
        Task {
            do {
                let detailedPlaylist = try await MCatalog.playlist(id: playlist.catalog.id, fetch: .tracks)
                tracks = detailedPlaylist.tracks ?? []
            } catch {
                print("Failed to fetch playlist using MLibrary: \(error)")
            }
        }
    }
}

