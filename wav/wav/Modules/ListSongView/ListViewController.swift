//
//  ListViewController.swift
//  wav
//
//  Created by Ilyes Djari on 08/05/2023.
//

import UIKit
import MusadoraKit
import MarqueeLabel

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // Outlets
    @IBOutlet weak var TrackCollectionView: UITableView! {
        didSet {
            TrackCollectionView.delegate = self
            TrackCollectionView.dataSource = self
        }
    }
    @IBOutlet weak var heightConstant: NSLayoutConstraint! 

    @IBOutlet weak var cover: UIImageView!
    @IBOutlet weak var playlistTitle: MarqueeLabel!
    @IBOutlet weak var backgroundGradient: UIView!
    // Properties
    var playlist: Playlist? {
        didSet {
            if let playlist {
                fetchPlaylist(playlist)
            }
        }
    }

    
    var tracks: MusicItemCollection<Track> = MusicItemCollection([]) {
        didSet {
            TrackCollectionView.reloadData()
            heightConstant.constant = CGFloat(Double(tracks.count) * 80)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    func configureUI() {
        playlistTitle.text = playlist?.name
        if let artworkURL = playlist?.artwork?.url(width: 500, height: 500) {
            let task = URLSession.shared.dataTask(with: artworkURL) { [weak self] data, response, error in
                if let error = error {
                    print("Error loading image: \(error.localizedDescription)")
                    return
                }
                guard let data = data else {
                    print("Error loading image: no data")
                    return
                }
                DispatchQueue.main.async {
                    self?.cover.image = UIImage(data: data)
                    if let color = self?.playlist?.artwork?.backgroundColor {
                        let uiColor = UIColor(cgColor: color)
                        if let backgroundView = self!.backgroundGradient {
                            addGradient(to: backgroundView, with: uiColor)
                        }
                    }
                }
            }
            task.resume()
        }
    }
}
