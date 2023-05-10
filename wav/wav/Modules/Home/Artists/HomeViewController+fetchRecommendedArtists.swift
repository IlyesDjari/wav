//
//  HomeViewController+fetchRecommendedArtists.swift
//  wav
//
//  Created by Ilyes Djari on 10/05/2023.
//

import Foundation
import UIKit
import MusadoraKit

extension HomeViewController {
    func fetchRecommendedArtists() {
        Task {
            do {
                fetchedArtists = try await MLibrary.artists(limit: 4)
                DispatchQueue.main.async { [self] in
                    RecommendedArtistCollectionView.reloadData()
                }
            } catch {
                print("Error fetching artists: \(error)")
            }
        }
    }
}
