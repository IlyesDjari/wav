//
//  ArtistViewController+TopSongs.swift
//  wav
//
//  Created by Ilyes Djari on 31/05/2023.
//

import Foundation
import MusadoraKit

import Foundation
import MusadoraKit

extension ArtistViewController {
    public func getArtistData() {
        Task {
            guard let artist = artist else {
                return
            }
            let artistID = try await MCatalog.searchArtists(for: artist.name, limit: 1)
            artistData = try await MCatalog.artist(id: artistID[0].id, fetch: .all)
            topCollectionView.reloadData()
        }
    }
}

