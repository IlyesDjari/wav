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
        recommendations = try await MRecommendation.personalAlbums(limit: 3)
        if recommendations.isEmpty {
            // Handle the case where no recommendations are available
            print("No recommended albums available")
        } else {
            var albumsAndImageViews: [(Album, UIImageView)] = []
            if recommendations.indices.contains(0) {
                albumsAndImageViews.append((recommendations[0], album1))
            }
            if recommendations.indices.contains(1) {
                albumsAndImageViews.append((recommendations[1], album2))
            }
            if recommendations.indices.contains(2) {
                albumsAndImageViews.append((recommendations[2], album3))
            }
            for (album, imageView) in albumsAndImageViews {
                if let artworkURL = album.artwork?.url(width: 500, height: 500) {
                    loadImage(with: artworkURL, into: imageView)
                }
            }
        }
    }

    @objc internal func albumTapped(_ sender: UITapGestureRecognizer) {
        guard let tappedImageView = sender.view as? UIImageView else { return }
        var selectedAlbum: Album?

        switch tappedImageView {
        case album1:
            if recommendations.indices.contains(0) {
                selectedAlbum = recommendations[0]
            }
        case album2:
            if recommendations.indices.contains(1) {
                selectedAlbum = recommendations[1]
            }
        case album3:
            if recommendations.indices.contains(2) {
                selectedAlbum = recommendations[2]
            }
        default:
            break
        }
        if let selectedAlbum = selectedAlbum {
            navigateToAlbumViewController(with: selectedAlbum)
        }
    }

    internal func navigateToAlbumViewController(with album: Album) {
        performSegue(withIdentifier: "homeToAlbumSegue", sender: album)
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
