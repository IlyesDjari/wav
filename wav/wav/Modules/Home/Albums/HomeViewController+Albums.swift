//
//  HomeViewController+Albums.swift
//  wav
//
//  Created by Ilyes Djari on 11/05/2023.
//

import Foundation
import MusadoraKit
import Kingfisher
import UIKit

extension HomeViewController {
    
    func fetchRecommendedAlbums() async throws {
            let recommendations = try await MRecommendation.defaultAlbums(limit: 3)
            if recommendations.isEmpty {
                // Handle the case where no recommendations are available
                print("No recommended albums available")
            } else {
                let albumsAndImageViews: [(Album, UIImageView)] = [
                    (recommendations[0], album1),
                    (recommendations[1], album2),
                    (recommendations[2], album3)
                ]
                for (album, imageView) in albumsAndImageViews {
                    if let artworkURL = album.artwork?.url(width: 500, height: 500) {
                        loadImage(with: artworkURL, into: imageView)
                    }
                }
            }
        }

        private func loadImage(with url: URL, into imageView: UIImageView) {
            imageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder")) { result in
                switch result {
                case .success(let value):
                    // Image loaded successfully
                    // You can perform any additional configuration here
                    print("Image loaded: \(value.source.url?.absoluteString ?? "")")
                case .failure(let error):
                    // Error occurred while loading image
                    print("Image loading failed: \(error)")
                }
            }
        }
}
