//
//  TopsSongsCollectionViewCell.swift
//  wav
//
//  Created by Ilyes Djari on 01/06/2023.
//

import UIKit
import MarqueeLabel

class TopsSongsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cover: UIImageView!
    @IBOutlet weak var songName: MarqueeLabel!
    @IBOutlet weak var artistName: MarqueeLabel!
}
