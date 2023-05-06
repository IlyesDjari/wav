//
//  PlayerViewController.swift
//  wav
//
//  Created by Ilyes Djari on 05/05/2023.
//

import UIKit
import MusicKit
import MediaPlayer
import MarqueeLabel
import MusadoraKit

protocol PlayerViewControllerDelegate: AnyObject {
    func playerViewController(_ controller: PlayerViewController, didSelectSongWithID songID: String?)
}

class PlayerViewController: UIViewController {

    // Outlets
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var cover: UIImageView!
    @IBOutlet weak var song: MarqueeLabel!
    @IBOutlet weak var artist: MarqueeLabel!
    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var stateButton: UIImageView!

    // Properties
    weak var homeViewController: HomeViewController?
    weak var delegate: PlayerViewControllerDelegate?
    internal var playbackStatusTimer: Timer?
    internal var lastPlaybackStatus: ApplicationMusicPlayer.PlaybackStatus?
    let player = ApplicationMusicPlayer.shared
    let musicPlaybackControl = MusicPlaybackControl()
    var songID: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        musicPlaybackControl.setStateButtonImage(stateButton: stateButton)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Register observers for selected song ID changes and playback state changes
        NotificationCenter.default.addObserver(self, selector: #selector(selectedSongIDChanged(_:)), name: .songIDChanged, object: nil)
        // Fetch the currently playing item or the selected song
        if let songID = songID {
            fetchPlayingSong(songID: songID)
            print("Now playing the selected song ID: \(songID)")
        } else {
            fetchPlayingSong(songID: nil)
        }
        // Set the initial state of the state button
        musicPlaybackControl.setStateButtonImage(stateButton: stateButton)
        // Check playback status
        playbackStatusTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(playbackStatusChanged), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Remove observers for selected song ID changes and playback state changes
        NotificationCenter.default.removeObserver(self, name: .songIDChanged, object: nil)
        // Remove the observer for playback status changes
        playbackStatusTimer?.invalidate()
    }

    private func configureUI() {
        addShadow(to: coverView)
    }

    @IBAction func stateButtonTapped(_ sender: UITapGestureRecognizer) {
        musicPlaybackControl.togglePlayback()
    }
}
