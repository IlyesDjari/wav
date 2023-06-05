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
import NearbyInteraction
import MultipeerConnectivity

protocol PlayerViewControllerDelegate: AnyObject {
    func playerViewController(_ controller: PlayerViewController, didSelectSongWithID songID: String?)
}

class PlayerViewController: UIViewController, NISessionDelegate {
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

    var session: NISession?
    var peerDiscoveryToken: NIDiscoveryToken?
    var mpc: MPCSession?
    var connectedPeer: MCPeerID?
    let impactGenerator = UIImpactFeedbackGenerator(style: .medium)
    var sharedTokenWithPeer = false
    var peerDisplayName: String?
    let nearbyDistanceThreshold: Float = 0.3
    var currentDistanceDirectionState: DistanceDirectionState = .unknown
    var lastVibrationDistance: Float?

    // Properties
    private lazy var debouncedSkipButtonTapped: (() -> Void) = {
        debounce(interval: 300, queue: .main) { [weak self] in
            Task {
                await self?.performSkipButtonTapped()
            }
        }
    }()
    private lazy var debouncedBackButtonTapped: (() -> Void) = {
        debounce(interval: 300, queue: .main) { [weak self] in
            Task {
                await self?.performBackButtonTapped()
            }
        }
    }()
    internal lazy var debouncedSongChanged: (() -> Void) = {
        debounce(interval: 500, queue: .main) { [weak self] in
            self?.performSongChanged()
        }
    }()
    var isLiveSharePopupShown: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "isLiveSharePopupShown")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isLiveSharePopupShown")
        }
    }

    weak var homeViewController: HomeViewController?
    weak var delegate: PlayerViewControllerDelegate?
    var playbackAndTimelineTimer: Timer?
    internal var lastPlaybackStatus: ApplicationMusicPlayer.PlaybackStatus?
    internal var lastPlayedSongID: String?
    internal var timelineEditing = false
    private var observer: NSObjectProtocol?
    public var sharePlay: Bool {
        get {
            return UserDefaultsManager.shared.getSharePlayStatus()
        }
        set {
            UserDefaultsManager.shared.saveSharePlayStatus(status: newValue)
            let discoverabilityStatus = UserDefaultsManager.shared.getDiscoverabilityStatus()
            if newValue && discoverabilityStatus {
                startup()
            }
        }
    }
    public var playlistIDs: Playlist? {
        didSet {
            if playlistIDs != nil {
                Task {
                    // Fetch the playlist and play it
                    try await player.play(playlist: playlistIDs!)
                    fetchPlayingSong(songID: songID)
                }
            }
        }
    }
    public var albumIDs: Album? {
        didSet {
            if albumIDs != nil {
                Task {
                    // Fetch the playlist and play it
                    try await player.play(album: albumIDs!)
                    fetchPlayingSong(songID: songID)
                }
            }
        }
    }
    public let player = ApplicationMusicPlayer.shared
    let musicPlaybackControl = MusicPlaybackControl()
    public var songID: String? {
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
        UserDefaultsManager.shared.setLiveSessionListening(false)
        // Fetch skipping songs
        observer = NotificationCenter.default.addObserver(forName: .MPMusicPlayerControllerNowPlayingItemDidChange, object: nil, queue: nil) { [weak self] _ in
            if let nextSongID = MPMusicPlayerController.applicationMusicPlayer.nowPlayingItem?.playbackStoreID {
                self?.songChanged(nextSongID: nextSongID)
            }
        }
        // Set the initial state of the state button
        musicPlaybackControl.setStateButtonImage(stateButton: stateButton)
        // Check playback status
        startUpdateTimers()
        // Add timeline observers
        timeline.addTarget(self, action: #selector(timelineValueChanged(_:)), for: .valueChanged)
        timeline.addTarget(self, action: #selector(timelineEditingBegan(_:)), for: .touchDown)
        timeline.addTarget(self, action: #selector(timelineEditingEnded(_:)), for: [.touchUpInside, .touchUpOutside])
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
        }
        // Remove the observer for playback status changes
        playbackAndTimelineTimer?.invalidate()
    }

    internal func startUpdateTimers() {
        playbackAndTimelineTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.playbackStatusChanged()
            self.updatePlaybackTime()
        }
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
        if sharePlay {
            if let entryID = player.queue.currentEntry?.item?.id {
                startLiveShareSession(songID: entryID.rawValue) { result in
                    switch result {
                    case .success:
                        self.musicPlaybackControl.setLiveShareSessionButton(liveSessionButton: self.liveShareButton, liveSessionLabel: self.liveShareLabel, sharePlayStatus: self.sharePlay)
                    case .failure(let error):
                        print("Failed to start live share session: \(error)")
                    }
                }
            } else {
                print("Error: currentEntry ID is nil.")
            }
        } else {
            stopLiveShareSession { result in
                switch result {
                case .success:
                    self.musicPlaybackControl.setLiveShareSessionButton(liveSessionButton: self.liveShareButton, liveSessionLabel: self.liveShareLabel, sharePlayStatus: self.sharePlay)
                case .failure(let error):
                    print("Failed to stop live share session: \(error)")
                }
            }
        }
    }

    private func performSkipButtonTapped() async {
        // Animate the button
        let animator = UIViewPropertyAnimator(duration: 0.0, dampingRatio: 0.8) {
            self.skipButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
        animator.addAnimations({
            self.skipButton.transform = CGAffineTransform.identity
        }, delayFactor: 0.5)
        animator.startAnimation()
        // Skip to the next song
        await self.musicPlaybackControl.skipToNextSong()
    }

    private func performBackButtonTapped() async {
        // Animate the button
        let animator = UIViewPropertyAnimator(duration: 0.0, dampingRatio: 0.8) {
            self.backButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
        animator.addAnimations({
            self.backButton.transform = CGAffineTransform.identity
        }, delayFactor: 0.5)
        animator.startAnimation()
        // Skip to the next song
        await self.musicPlaybackControl.skipToPreviousSong()
    }

    private func startup() {
        print("called")
        // Create the NISession.
        session = NISession()
        // Set the delegate.
        session?.delegate = self
        // Because the session is new, reset the token-shared flag.
        sharedTokenWithPeer = false
        // If `connectedPeer` exists, share the discovery token, if needed.
        if connectedPeer != nil && mpc != nil {
            if let myToken = session?.discoveryToken {
                if !sharedTokenWithPeer {
                    shareMyDiscoveryToken(token: myToken)
                }
                guard let peerToken = peerDiscoveryToken else {
                    return
                }
                let config = NINearbyPeerConfiguration(peerToken: peerToken)
                session?.run(config)
            } else {
                fatalError("Unable to get self discovery token, is this session invalidated?")
            }
        } else {
            startupMPC()
            currentDistanceDirectionState = .unknown
        }
    }

    private func showDataRemovedNotification() {
        // Create the notification banner
        let banner = NotificationBanner(title: "Data Removed", subtitle: "All your data has been successfully removed", style: .success)
        // Customize the banner appearance if needed
        banner.backgroundColor = .systemGreen
        // Show the banner
        banner.show()
        // Automatically dismiss the banner after a delay
        banner.autoDismiss = true
    }

    @IBAction func stateButtonTapped(_ sender: UITapGestureRecognizer) {
        musicPlaybackControl.togglePlayback()
        musicPlaybackControl.setStateButtonImage(stateButton: stateButton)
    }

    @IBAction func skipButtonTapped(_ sender: Any) {
        debouncedSkipButtonTapped()
    }

    @IBAction func tapPrevious(_ sender: Any) {
        debouncedBackButtonTapped()
    }

    @IBAction func tapShuffle(_ sender: Any) {
        musicPlaybackControl.toggleShuffleMode(shuffleModeButton: shuffleButton)
    }
    @IBAction func tapRepeat(_ sender: Any) {
        musicPlaybackControl.toggleRepeatMode(repeatModeButton: repeatOnce)
    }

    @IBAction func tappedLiveShare(_ sender: Any) {
        if !sharePlay {
            if !isLiveSharePopupShown {
                // Create the alert controller
                let alertController = UIAlertController(title: "Live Sharing", message: "Your location and current song will be shared for live sharing. This data will only be used during the session and will be removed immediately after it ends.", preferredStyle: .alert)
                // Add an OK action to dismiss the alert
                let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                    self.isLiveSharePopupShown = true
                }
                alertController.addAction(okAction)
                // Present the alert controller
                present(alertController, animated: true, completion: nil)
            }
            self.sharePlay.toggle()
            self.updateLiveShare()
        } else {
            self.sharePlay.toggle()
            self.updateLiveShare()
            if !sharePlay {
                showDataRemovedNotification()
            }
        }
    }
}
