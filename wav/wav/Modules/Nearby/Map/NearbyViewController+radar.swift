//
//  NearbyViewController+radar.swift
//  wav
//
//  Created by Ilyes Djari on 16/05/2023.
//

import Foundation
import HGRippleRadarView
import UIKit
import Kingfisher
import MusadoraKit
import CoreLocation

extension NearbyViewController: RadarViewDelegate, RadarViewDataSource {

    func radarView(radarView: HGRippleRadarView.RadarView, didSelect item: HGRippleRadarView.Item) {

        let view = radarView.view(for: item)
        enlarge(view: view)

        guard let user = item.value as? NearbyUser else {
            return
        }
        if let index = usersData.firstIndex(where: { $0.id == user.id }) {
            let indexPath = IndexPath(row: index, section: 0)
            // Scroll to the corresponding cell in the tableView
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            // Highlight the corresponding cell
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }
    }

    func radarView(radarView: HGRippleRadarView.RadarView, didDeselectAllItems lastSelectedItem: HGRippleRadarView.Item) {
        let view = radarView.view(for: lastSelectedItem)
        reduce(view: view)

        guard let user = lastSelectedItem.value as? NearbyUser,
              let index = usersData.firstIndex(where: { $0.id == user.id }) else {
            return
        }
        let indexPath = IndexPath(row: index, section: 0)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func radarView(radarView: RadarView, didDeselect item: Item) {

        let view = radarView.view(for: item)
        reduce(view: view)

        guard let user = item.value as? NearbyUser,
              let index = usersData.firstIndex(where: { $0.id == user.id }) else {
            return
        }
        let indexPath = IndexPath(row: index, section: 0)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func radarView(radarView: RadarView, viewFor item: Item, preferredSize: CGSize) -> UIView {
        let user = item.value as? NearbyUser
        let frame = CGRect(x: 0, y: 0, width: preferredSize.width, height: preferredSize.height)
        let imageView = UIImageView(frame: frame)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = preferredSize.width / 2
        imageView.clipsToBounds = true
        Task {
            if let songID = user?.songID {
                do {
                    let song = try await MCatalog.song(id: MusicItemID(rawValue: songID))
                    if let imageURL = song.artwork?.url(width: 200, height: 200) {
                        imageView.kf.setImage(with: imageURL)
                    } else {
                        imageView.image = UIImage(named: "NoCoverImage")
                    }
                } catch {
                    print("Error retrieving song: \(error)")
                    imageView.image = UIImage(named: "NoCoverImage")
                }
            } else {
                imageView.image = UIImage(named: "NoCoverImage")
            }
        }

        return imageView
    }

    private func enlarge(view: UIView?) {
            let animation = Animation.transform(from: 1.0, to: 1.5)
            animation.fillMode = .forwards
            animation.isRemovedOnCompletion = false
            view?.layer.add(animation, forKey: "transform")
    }

    private func reduce(view: UIView?) {
            let animation = Animation.transform(from: 1.5, to: 1.0)
            animation.fillMode = .forwards
            animation.isRemovedOnCompletion = false
            view?.layer.add(animation, forKey: "transform")
    }

    func setRadar() {
        radarView.diskRadius = 10.0
        radarView.diskColor = UIColor(named: "Purple")!
        radarView.circleOnColor = UIColor(named: "Purple")!
        radarView.circleOffColor = UIColor(named: "defaultPlayerBackground")!
        radarView.paddingBetweenCircles = 60
        radarView.animationDuration = 2
    }
}
