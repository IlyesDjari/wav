//
//  NearbyUsersTableViewCell.swift
//  wav
//
//  Created by Ilyes Djari on 16/05/2023.
//

import UIKit
import MarqueeLabel

class NearbyUsersTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet weak var cover: UIImageView!
    @IBOutlet weak var songName: MarqueeLabel!
    @IBOutlet weak var artist: MarqueeLabel!
}
