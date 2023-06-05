//
//  AlbumViewController.swift
//  wav
//
//  Created by Ilyes Djari on 26/05/2023.
//

import UIKit
import MarqueeLabel
import MusadoraKit
import NotificationBannerSwift

class AlbumViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // Outlets
    @IBOutlet weak var albumTitle: MarqueeLabel!
    @IBOutlet weak var artistName: MarqueeLabel!
    @IBOutlet weak var cover: UIImageView!
    @IBOutlet weak var backgroundGradient: UIView!
    @IBOutlet weak var heightConstant: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    // Properties
    var tracks: MusicItemCollection<Track> = MusicItemCollection([]) {
        didSet {
            UIView.transition(with: tableView, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.tableView.reloadData()
            }, completion: { _ in
                let indexPaths = (0..<self.tracks.count).map { IndexPath(row: $0, section: 0) }
                self.tableView.reloadRows(at: indexPaths, with: .fade)
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            })
            heightConstant.constant = CGFloat(Double(tracks.count) * 65)
        }
    }

    var album: Album? {
        didSet {
            if let album {
                fetchAlbum(album)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    private func configureUI() {
        albumTitle.text = album?.title
        artistName.text = album?.artistName
        if let artworkURL = album?.artwork?.url(width: 500, height: 500) {
            let task = URLSession.shared.dataTask(with: artworkURL) { [weak self] data, _, error in
                if let error {
                    NotificationBanner.showErrorBanner(title: "Error", subtitle: "Error loading image: \(error.localizedDescription)")

                    return
                }
                guard let data else {
                    NotificationBanner.showErrorBanner(title: "Error", subtitle: "Error loading image: no data")

                    return
                }
                DispatchQueue.main.async {
                    self?.cover.image = UIImage(data: data)
                    if let color = self?.album?.artwork?.backgroundColor {
                        let uiColor = UIColor(cgColor: color)
                        if let backgroundView = self!.backgroundGradient {
                            addGradient(to: backgroundView, with: uiColor)
                        }
                        if let superview = self!.view.superview {
                            self!.backgroundGradient.frame = superview.bounds
                        }
                    }
                }
            }
            task.resume()
        }
    }

}
