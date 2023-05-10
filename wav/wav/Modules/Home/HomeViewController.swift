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

class HomeViewController: UIViewController, UICollectionViewDelegate, PlayerViewControllerDelegate {
    
    // Outlets
    @IBOutlet weak var HistoryCollectionView: UICollectionView! {
        didSet {
            HistoryCollectionView.dataSource = self
            HistoryCollectionView.delegate = self
            
        }
    }
    
    @IBOutlet weak var ForYouCollectionView: UICollectionView! {
        didSet {
            ForYouCollectionView.dataSource = self
            ForYouCollectionView.delegate = self
            
        }
    }
    
    @IBOutlet weak var RecommendedArtistCollectionView: UICollectionView! {
        didSet {
            RecommendedArtistCollectionView.dataSource = self
            RecommendedArtistCollectionView.delegate = self
        }
    }
    
    @IBOutlet weak var noSongLabel: MarqueeLabel!
    @IBOutlet weak var SeeMoreButton: UIView!
    @IBOutlet weak var homePlayer: UIView!
    @IBOutlet weak var currentArtist: MarqueeLabel!
    @IBOutlet weak var currentSong: MarqueeLabel!
    @IBOutlet weak var currentCover: UIImageView!
    @IBOutlet weak var stateButton: UIImageView!
    
    // Properties
    public var recentItems: [RecentItem] = []
    public var recommendedStations: [Playlist] = []
    var fetchedArtists: MusicItemCollection<Artist> = MusicItemCollection([])
    public var songID: String?
    internal var playbackStatusTimer: Timer?
    internal var lastPlaybackStatus: ApplicationMusicPlayer.PlaybackStatus?
    public let musicPlaybackControl = MusicPlaybackControl()
    public let player = ApplicationMusicPlayer.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchAllData()
    }
    
    func playerViewController(_ controller: PlayerViewController, didSelectSongWithID songID: String?) {
        self.songID = songID
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
                if let songID = songID {
                    fetchCurrentlyPlaying(songID: songID)
                } else {
                    fetchCurrentlyPlaying(songID: nil)
                }
                try await fetchRecommendedStations()
                fetchRecommendedArtists()
                // Remove the loading view when the data is loaded
                loadingView.removeFromSuperview()
                view.isUserInteractionEnabled = true
            } catch {
                print("Error fetching data: \(error.localizedDescription)")
            }
        }
    }
    
    @IBAction func stateTapped(_ sender: Any) {
        musicPlaybackControl.togglePlayback()
    }
}
