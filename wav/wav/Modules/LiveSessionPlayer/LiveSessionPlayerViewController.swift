//
//  LiveSessionPlayerViewController.swift
//  wav
//
//  Created by Ilyes Djari on 17/05/2023.
//

import UIKit
import MarqueeLabel
import FirebaseFirestore

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

    private var firestoreListener: ListenerRegistration?
    private var firestoreRef: DocumentReference?

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAllData()
        handleLiveSessionListening()
        UserDefaultsManager.shared.setLiveSessionListening(true)
        TabBarViewController.shared.liveSessionPlayerViewController = self
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
            } else if let error = error {
                print("Error fetching document: \(error)")
            } else {
                print("Document does not exist")
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

}
