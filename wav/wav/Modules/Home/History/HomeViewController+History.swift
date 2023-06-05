//
//  HomeViewController+History.swift
//  wav
//
//  Created by Ilyes Djari on 03/05/2023.
//

import Foundation
import UIKit
import MusadoraKit
import Kingfisher

extension HomeViewController {

    internal func fetchRecentlyPlayed() async throws {
        let recentlyPlayedSongs = try await MLibrary.recentlyPlayedSongs(offset: 0)
        recentItems = recentlyPlayedSongs.map { song in
            RecentItem(song: song)
        }
        // Reload the collection view data on the main thread
        DispatchQueue.main.async {
            self.historyCollectionView.reloadData()
        }
    }
}
