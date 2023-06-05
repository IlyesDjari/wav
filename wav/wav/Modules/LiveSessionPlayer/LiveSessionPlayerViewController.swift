//
//  LiveSessionPlayerViewController.swift
//  wav
//
//  Created by Ilyes Djari on 17/05/2023.
//

import UIKit
import MarqueeLabel
import FirebaseFirestore
import NotificationBannerSwift

class LiveSessionPlayerViewController: UIViewController {
    
    // Properties
    var playbackTimer: Timer?
    private var firestoreListener: ListenerRegistration?
    private var firestoreRef: DocumentReference?
    let musicPlaybackControl = MusicPlaybackControl()
    internal var usersData: NearbyUser? = nil
    
    // Outlets
    @IBOutlet weak var playingCover: UIImageView!
    @IBOutlet weak var currentSongName: MarqueeLabel!
    @IBOutlet weak var currentArtist: MarqueeLabel!
    @IBOutlet weak var suggestView: UIView!
    @IBOutlet weak var suggestCover: UIImageView!
    @IBOutlet weak var suggestLabel: UILabel!
    @IBOutlet weak var stateButton: UIImageView!
    @IBOutlet weak var userLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAllData()
        handleLiveSessionListening()
        UserDefaultsManager.shared.setLiveSessionListening(true)
        TabBarViewController.shared.liveSessionPlayerViewController = self
        // Set the initial state of the state button
        musicPlaybackControl.setStateButtonImage(stateButton: stateButton)
        // Check playback status
        startUpdateTimers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        playbackTimer?.invalidate()
    
    }
    
    internal func startUpdateTimers() {
        playbackTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.playbackStatusChanged()
        }
    }

    @objc func playbackStatusChanged() {
        musicPlaybackControl.setStateButtonImage(stateButton: stateButton)
    }
    
    private func fetchAllData() {
        guard let usersData = usersData else { return }
        getSongInfo(songID: usersData.songID)
        setSuggestion(songID: usersData.favoriteSong)
        setUserLabel()
    }

    private func setUserLabel() {
        guard let usersData = usersData else { return }
        userLabel.text = "You're listening with \(usersData.username) who truly loves \(usersData.favoriteGenre)"
    }

    private func handleLiveSessionListening() {
        let isLiveSessionListening = UserDefaultsManager.shared.isLiveSessionListening()
        if isLiveSessionListening {
            observeCurrentlyPlaying()
        } else {
            stopObservingCurrentlyPlaying()
        }
    }

    private func observeCurrentlyPlaying() {
        guard let usersData = usersData, firestoreRef == nil else { return }
        // Create Firestore reference to the user document
        firestoreRef = Firestore.firestore().collection("Users").document(usersData.id)
        // Start listening to changes in the currentlyPlaying field
        firestoreListener = firestoreRef?.addSnapshotListener { [weak self] documentSnapshot, error in
            guard let self = self else { return }
            if let document = documentSnapshot, document.exists {
                if let songID = document.get("currentSong") as? String {
                    print("Document data: \(document.data() ?? [:])")
                    print("Song changed: \(songID)")
                    self.handleSongChanged(songID)
                } else {
                    print("No 'currentlyPlaying' field found in the document")
                }
            } else if let error {
                NotificationBanner.showErrorBanner(title: "Error", subtitle: "Error fetching document: \(error)")
            } else {
                NotificationBanner.showErrorBanner(title: "Error", subtitle: "Something went wrong!")
            }
        }
    }

    private func stopObservingCurrentlyPlaying() {
        firestoreListener?.remove()
        firestoreListener = nil
        firestoreRef = nil
    }

    private func handleSongChanged(_ songID: String) {
        getSongInfo(songID: songID)
    }
    
    @IBAction func stateButtonTapped(_ sender: Any) {
        musicPlaybackControl.togglePlayback()
        musicPlaybackControl.setStateButtonImage(stateButton: stateButton)
    }
}
