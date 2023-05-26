//
//  AlbumTracksTableViewCell.swift
//  wav
//
//  Created by Ilyes Djari on 26/05/2023.
//

import UIKit
import MarqueeLabel

class AlbumTracksTableViewCell: UITableViewCell {
    @IBOutlet weak var songTitle: MarqueeLabel!
    @IBOutlet weak var songNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
