//
//  shadowView.swift
//  wav
//
//  Created by Ilyes Djari on 04/05/2023.
//

import Foundation
import UIKit

func addShadow(to view: UIView) {
    view.layer.shadowColor = UIColor.black.cgColor
    view.layer.shadowOpacity = 0.3
    view.layer.shadowOffset = CGSize(width: 3, height: 6)
    view.layer.shadowRadius = 6
    view.layer.shouldRasterize = true
    view.layer.rasterizationScale = UIScreen.main.scale
}
