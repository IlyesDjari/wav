//
//  TracksTableViewCell.swift
//  wav
//
//  Created by Ilyes Djari on 10/05/2023.
//

import UIKit
import MarqueeLabel

class TracksTableViewCell: UITableViewCell {
    
    @IBOutlet weak var songLabel: MarqueeLabel!
    @IBOutlet weak var artistLabel: MarqueeLabel!
    @IBOutlet weak var cover: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
