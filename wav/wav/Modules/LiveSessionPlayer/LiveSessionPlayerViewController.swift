//
//  LiveSessionPlayerViewController.swift
//  wav
//
//  Created by Ilyes Djari on 17/05/2023.
//

import UIKit
import MarqueeLabel

class LiveSessionPlayerViewController: UIViewController {
    
    // Properties
    internal var usersData: NearbyUser? = nil
    @IBOutlet weak var playingCover: UIImageView!
    @IBOutlet weak var currentSongName: MarqueeLabel!
    @IBOutlet weak var currentArtist: MarqueeLabel!
    @IBOutlet weak var suggestView: UIView!
    @IBOutlet weak var suggestCover: UIImageView!
    @IBOutlet weak var suggestLabel: UILabel!
    
    // Outlets
    @IBOutlet weak var userLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAllData()
    }
    
    private func fetchAllData() {
        guard let usersData = usersData else { return }
        getSongInfo(songID: usersData.songID)
        setSuggestion(songID: usersData.favoriteSong)
        setUserLabel()
    }
    
    private func setUserLabel() {
        guard let usersData = usersData else { return }
        userLabel.text = "You're listening with \(usersData.username) who is 20 years old and truly loves \(usersData.favoriteGenre)"
    }
}
