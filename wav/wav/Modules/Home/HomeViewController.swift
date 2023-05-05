//
//  HomeViewController.swift
//  wav
//
//  Created by Ilyes Djari on 02/05/2023.
//

import UIKit
import MusicKit
import MusadoraKit
import MarqueeLabel

class HomeViewController: UIViewController {

    // Outlets
    @IBOutlet weak var HistoryCollectionView: UICollectionView! {
        didSet {
            HistoryCollectionView.dataSource = self
        }
    }
    @IBOutlet weak var SeeMoreButton: UIView!
    @IBOutlet weak var homePlayer: UIView!
    @IBOutlet weak var currentArtist: MarqueeLabel!
    @IBOutlet weak var currentSong: MarqueeLabel!
    @IBOutlet weak var currentCover: UIImageView!
    @IBOutlet weak var stateButton: UIImageView!
    
    // Properties
    public var recentItems: [RecentItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchAllData()
        // Set the data source for the collection view
    }

    private func configureUI() {
        addShadow(to: homePlayer)
        addShadow(to: SeeMoreButton)
    }

    private func fetchAllData() {
        // Show the loading view
        let loadingView = showLoadingView(on: view)

        Task {
            do {
                try await fetchRecentlyPlayed()
                fetchCurrentlyPlaying()

                // Remove the loading view when the data is loaded
                loadingView.removeFromSuperview()
                view.isUserInteractionEnabled = true
            } catch {
                print("Error fetching recently played items: \(error.localizedDescription)")
            }
        }
    }

    private func fetchRecentlyPlayed() async throws {
        let recentlyPlayedSongs = try await MLibrary.recentlyPlayedSongs(offset: 0)
        recentItems = recentlyPlayedSongs.map { song in
            RecentItem(song: song)
        }
        // Reload the collection view data on the main thread
        DispatchQueue.main.async {
            self.HistoryCollectionView.reloadData()
        }
    }

    private func updateRecentUI() {
        for item in recentItems {
            print(item.song?.title as Any)
        }
    }
    
    @IBAction func stateTapped(_ sender: Any) {
        togglePlayback()
        print("tapped")
    }
}
