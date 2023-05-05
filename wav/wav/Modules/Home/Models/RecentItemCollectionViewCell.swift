//
//  RecentItemCollectionViewCell.swift
//  wav
//
//  Created by Ilyes Djari on 03/05/2023.
//

import Foundation
import UIKit
import MarqueeLabel

class RecentItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cover: UIImageView!
    @IBOutlet weak var artist: MarqueeLabel!
    @IBOutlet weak var song: MarqueeLabel!
}
