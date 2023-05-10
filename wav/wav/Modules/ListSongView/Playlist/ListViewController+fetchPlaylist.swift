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
            let detailedPlaylist = try await MCatalog.playlist(id: playlist.id, fetch: .tracks)
            tracks = detailedPlaylist.tracks ?? []
        }
    }
}
