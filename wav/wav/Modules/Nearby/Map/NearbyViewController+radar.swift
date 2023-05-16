//
//  NearbyViewController+radar.swift
//  wav
//
//  Created by Ilyes Djari on 16/05/2023.
//

import Foundation
import HGRippleRadarView
import UIKit

extension NearbyViewController: RadarViewDelegate, RadarViewDataSource {
    func radarView(radarView: HGRippleRadarView.RadarView, didSelect item: HGRippleRadarView.Item) {
        print("select")
    }
    
    func radarView(radarView: HGRippleRadarView.RadarView, didDeselect item: HGRippleRadarView.Item) {
        print("deselect")

    }
    
    func numberOfItems(in radarView: RadarView) -> Int {
        print("called")
        return usersData.count
    }
    
    func radarView(radarView: RadarView, viewFor item: Item, preferredSize: CGSize) -> UIView {
        let user = item.value as? NearbyUser
        let frame = CGRect(x: 0, y: 0, width: preferredSize.width, height: preferredSize.height)
        let imageView = UIImageView(frame: frame)
        let image =  UIImage(named: "NoCoverImage")
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        return imageView
    }
    
    func radarView(radarView: HGRippleRadarView.RadarView, didDeselectAllItems lastSelectedItem: HGRippleRadarView.Item) {
        print("last")
    }
    
    
    func setRadar() {
        radarView.diskRadius = 10.0
        radarView.diskColor = UIColor(named: "Purple")!
        radarView.circleOnColor = UIColor(named: "Purple")!
        radarView.circleOffColor = UIColor(named: "defaultPlayerBackground")!
    }
}
