//
//  HomeViewController+Stations.swift
//  wav
//
//  Created by Ilyes Djari on 05/05/2023.
//

import Foundation
import MusadoraKit
import MusicKit
import Kingfisher
import UIKit

extension HomeViewController: UICollectionViewDataSource {

    func fetchRecommendedStations() async throws {
        let recommendations = try await MRecommendation.default(limit: 5)
        if recommendations.isEmpty {
            // Handle the case where no recommendations are available
            print("No recommended stations available")
        } else {
            // Save the recommended stations to the instance variable
            recommendedStations = recommendations.flatMap { $0.playlists }
            // Reload the collection view data on the main thread
            DispatchQueue.main.async {
                self.forYouCollectionView.reloadData()
            }
        }
    }
}
