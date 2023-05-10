//
//  addGradient.swift
//  wav
//
//  Created by Ilyes Djari on 10/05/2023.
//

import Foundation
import UIKit

func addGradient(to view: UIView, with color: UIColor) {
    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = [color.cgColor, UIColor.clear.cgColor]
    gradientLayer.locations = [0.0, 1.0]
    gradientLayer.frame = view.bounds
    view.layer.insertSublayer(gradientLayer, at: 0)
}
