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
    let player = ApplicationMusicPlayer.shared
    let musicPlaybackControl = MusicPlaybackControl()
    var songID: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchPlayingSong(songID: songID)
        musicPlaybackControl.setStateButtonImage(stateButton: stateButton)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.playerViewController(self, didSelectSongWithID: songID)
        if let songID = songID {
            NotificationCenter.default.post(name: .songIDChanged, object: nil, userInfo: ["songID": songID])
        }
    }

    private func configureUI() {
        addShadow(to: coverView)
    }

    @IBAction func stateButtonTapped(_ sender: UITapGestureRecognizer) {
        musicPlaybackControl.togglePlayback()
    }
}
