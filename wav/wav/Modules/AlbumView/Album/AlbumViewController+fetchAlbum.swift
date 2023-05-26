//
//  AlbumViewController+fetchAlbum.swift
//  wav
//
//  Created by Ilyes Djari on 26/05/2023.
//

import Foundation
import MusadoraKit

extension AlbumViewController {
    
    internal func fetchAlbum(_ album : Album) {
        Task {
            let detailedPlaylist = try await MCatalog.album(id: album.id, fetch: .tracks)
            tracks = detailedPlaylist.tracks ?? []
        }
    }
    
}
