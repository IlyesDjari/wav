//
//  PlayerViewController.swift
//  wav
//
//  Created by Ilyes Djari on 05/05/2023.
//

import UIKit
import MusicKit
import MarqueeLabel
import MusadoraKit
import MediaPlayer
import NotificationBannerSwift

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
    @IBOutlet weak var currentTime: UILabel!
    @IBOutlet weak var songTime: UILabel!
    @IBOutlet weak var timeline: UISlider!
    @IBOutlet weak var skipButton: UIImageView!
    @IBOutlet weak var backButton: UIImageView!
    @IBOutlet weak var repeatOnce: UIImageView!
    @IBOutlet weak var liveShareButton: UIImageView!
    @IBOutlet weak var liveShareLabel: MarqueeLabel!
    @IBOutlet weak var shuffleButton: UIImageView!
    // Properties
    weak var homeViewController: HomeViewController?
    weak var delegate: PlayerViewControllerDelegate?
    internal var playbackStatusTimer: Timer?
    internal var timelineTimer: Timer?
    internal var lastPlaybackStatus: ApplicationMusicPlayer.PlaybackStatus?
    internal var lastPlayedSongID: String?
    internal var timelineEditing = false
    public var sharePlay: Bool {
        get {
            return UserDefaultsManager.shared.getSharePlayStatus()
        }
        set {
            UserDefaultsManager.shared.saveSharePlayStatus(status: newValue)
        }
    }
    let player = ApplicationMusicPlayer.shared
    let musicPlaybackControl = MusicPlaybackControl()
    var songID: String? {
        didSet {
            if let unwrappedSongID = songID {
                // Fetch the song with the given ID
                fetchPlayingSong(songID: unwrappedSongID)
                // Call startLiveShareSession when songID changes and sharePlay is true
                updateLiveShare()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Fetch skipping songs
        NotificationCenter.default.addObserver(forName: .MPMusicPlayerControllerNowPlayingItemDidChange, object: nil, queue: nil) { _ in
            if let nextSongID = MPMusicPlayerController.applicationMusicPlayer.nowPlayingItem?.playbackStoreID {
                self.songChanged(nextSongID: nextSongID)
            }
        }
        // Set the initial state of the state button
        musicPlaybackControl.setStateButtonImage(stateButton: stateButton)
        // Check playback status
        playbackStatusTimer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { _ in
            self.playbackStatusChanged()
        }
        // Add timeline observers
        timeline.addTarget(self, action: #selector(timelineValueChanged(_:)), for: .valueChanged)
        timeline.addTarget(self, action: #selector(timelineEditingBegan(_:)), for: .touchDown)
        timeline.addTarget(self, action: #selector(timelineEditingEnded(_:)), for: [.touchUpInside, .touchUpOutside])
        // Start the timer to update the playback time every 0.5 second
        timelineTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            self.updatePlaybackTime()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Remove the observer for playback status changes
        playbackStatusTimer?.invalidate()
        timelineTimer?.invalidate()
    }

    private func configureUI() {
        addShadow(to: coverView)
        musicPlaybackControl.setShuffleModeButtonImage(shuffleModeButton: shuffleButton)
        musicPlaybackControl.setRepeatModeButtonImage(repeatModeButton: repeatOnce)
    }

    private func setupRemoteTransportControls() {
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.skipForwardCommand.addTarget { event in
            // Handle skip forward command here
            return .success
        }
        commandCenter.skipBackwardCommand.addTarget { event in
            // Handle skip backward command here
            return .success
        }
        NotificationCenter.default.addObserver(forName: .MPMusicPlayerControllerNowPlayingItemDidChange, object: nil, queue: .main) { [weak self] notification in
            guard let self = self else { return }
            guard let nowPlayingItem = MPMusicPlayerController.systemMusicPlayer.nowPlayingItem else { return }
            let nowPlayingSongID = nowPlayingItem.playbackStoreID
            self.songChanged(nextSongID: nowPlayingSongID)
        }
    }
    
    private func updateLiveShare() {
        guard let unwrappedSongID = songID else {
            print("Error: songID is nil.")
            return
        }
        if sharePlay {
            startLiveShareSession(songID: unwrappedSongID) { result in
                switch result {
                case .success:
                    self.musicPlaybackControl.setLiveShareSessionButton(liveSessionButton: self.liveShareButton, liveSessionLabel: self.liveShareLabel, sharePlayStatus: self.sharePlay)
                case .failure(let error):
                    print("Failed to start live share session: \(error)")
                }
            }
        } else {
            stopLiveShareSession{ result in
                switch result {
                case .success:
                    self.musicPlaybackControl.setLiveShareSessionButton(liveSessionButton: self.liveShareButton, liveSessionLabel: self.liveShareLabel, sharePlayStatus: self.sharePlay)
                case .failure(let error):
                    print("Failed to stop live share session: \(error)")
                }
            }
        }
    }


    @IBAction func stateButtonTapped(_ sender: UITapGestureRecognizer) {
        musicPlaybackControl.togglePlayback()
    }

    @IBAction func skipButtonTapped(_ sender: Any) {
        // Animate the button
        let animator = UIViewPropertyAnimator(duration: 0.0, dampingRatio: 0.8) {
            self.skipButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
        animator.addAnimations({
            self.skipButton.transform = CGAffineTransform.identity
        }, delayFactor: 0.5)
        animator.startAnimation()

        // Skip to the next song
        Task { @MainActor in
            await musicPlaybackControl.skipToNextSong()
        }
    }

    @IBAction func tapPrevious(_ sender: Any) {
        // Animate the button
        let animator = UIViewPropertyAnimator(duration: 0.0, dampingRatio: 0.8) {
            self.backButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
        animator.addAnimations({
            self.backButton.transform = CGAffineTransform.identity
        }, delayFactor: 0.5)
        animator.startAnimation()
        Task { @MainActor in
            await musicPlaybackControl.skipToPreviousSong()
        }
    }
    
    @IBAction func tapShuffle(_ sender: Any) {
        musicPlaybackControl.toggleShuffleMode(shuffleModeButton: shuffleButton)
    }
    @IBAction func tapRepeat(_ sender: Any) {
        musicPlaybackControl.toggleRepeatMode(repeatModeButton: repeatOnce)
    }
    
    @IBAction func tappedLiveShare(_ sender: Any) {
        sharePlay.toggle()
        updateLiveShare()
    }
}
