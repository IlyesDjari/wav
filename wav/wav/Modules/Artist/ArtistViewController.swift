//
//  ArtistViewController.swift
//  wav
//
//  Created by Ilyes Djari on 31/05/2023.
//

import UIKit
import MusadoraKit
import Kingfisher

class ArtistViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    

    // Properties
    internal var artist: Artist?
    internal var artistData: Artist?
    private var loadingIndicatorView: LoadingIndicatorView?

    // Outlets
    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var topCollectionView: UICollectionView! {
        didSet {
            topCollectionView.dataSource = self
            topCollectionView.delegate = self
        }
    }
    @IBOutlet weak var albumCollectionView: UICollectionView! {
        didSet {
            albumCollectionView.dataSource = self
            albumCollectionView.delegate = self
        }
    }
    @IBOutlet weak var playlistCollectionView: UICollectionView! {
        didSet {
            playlistCollectionView.dataSource = self
            playlistCollectionView.delegate = self
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoadingView()
        fetchAllData()
    }
    
    private func fetchAllData() {
        Task {
            setArtistInfo()
            getArtistData()
        }
    }
    
    private func setArtistInfo(completion: (() -> Void)? = nil) {
        guard let artist = artist else {
            return
        }
        // Set Artist Info
        artistName.text = artist.name
        // Set artist image<
        if let artworkURL = artist.artwork?.url(width: 500, height: 500) {
            DispatchQueue.global().async {
                if let imageData = try? Data(contentsOf: artworkURL),
                   let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        self.artistImageView.image = image
                        completion?()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.artistImageView.image = UIImage(named: "NoCoverImage")
                        completion?()
                    }
                }
            }
        } else {
            artistImageView.image = UIImage(named: "NoCoverImage")
            completion?()
        }
    }
    
    private func showLoadingView() {
        loadingIndicatorView = LoadingIndicatorView()
        loadingIndicatorView?.show(on: view)
    }

    internal func hideLoadingView() {
        loadingIndicatorView?.hide()
        loadingIndicatorView = nil
    }
}
