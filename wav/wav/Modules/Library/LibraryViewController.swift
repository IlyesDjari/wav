//
//  LibraryViewController.swift
//  wav
//
//  Created by Ilyes Djari on 08/05/2023.
//

import UIKit
import MusadoraKit

class LibraryViewController: UIViewController, UICollectionViewDelegate {

    // Outlets

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }

    // Properties
    internal var playlists: MusicItemCollection<Playlist> = MusicItemCollection([])

    // Loading spinner
    let activityIndicator = UIActivityIndicatorView(style: .medium)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupActivityIndicator()
        fetchLibrary()
    }

    func setupActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

}
