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

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchLibrary()
    }
}
