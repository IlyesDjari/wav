//
//  ListViewController.swift
//  wav
//
//  Created by Ilyes Djari on 08/05/2023.
//

import UIKit
import MusadoraKit
import MarqueeLabel
import NotificationBannerSwift

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
            UIView.transition(with: TrackCollectionView, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.TrackCollectionView.reloadData()
            }, completion: { _ in
                let indexPaths = (0..<self.tracks.count).map { IndexPath(row: $0, section: 0) }
                self.TrackCollectionView.reloadRows(at: indexPaths, with: .fade)
                self.TrackCollectionView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            })
            heightConstant.constant = CGFloat(Double(tracks.count) * 80)
        }
    }
    private var loadingIndicatorView: LoadingIndicatorView?

    override func viewDidLoad() {
        super.viewDidLoad()
        showLoadingView()
        configureUI()
    }

    private func configureUI() {
        playlistTitle.text = playlist?.name
        if let artworkURL = playlist?.artwork?.url(width: 500, height: 500) {
            let task = URLSession.shared.dataTask(with: artworkURL) { [weak self] data, response, error in
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
                    if let color = self?.playlist?.artwork?.backgroundColor {
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
    
    private func showLoadingView() {
        loadingIndicatorView = LoadingIndicatorView()
        loadingIndicatorView?.show(on: view)
    }

    internal func hideLoadingView() {
        loadingIndicatorView?.hide()
        loadingIndicatorView = nil
    }
}
