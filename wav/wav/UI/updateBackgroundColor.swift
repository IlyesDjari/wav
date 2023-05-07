//
//  updateBackgroundColor.swift
//  wav
//
//  Created by Ilyes Djari on 05/05/2023.
//

import Foundation
import UIKit
import UIImageColors

public func updateBackgroundColor(from image: UIImage?, in view: UIView) {
    guard let image = image else { return }

    image.getColors { [weak view] colors in
        guard let view = view, let primaryColor = colors?.primary, let secondaryColor = colors?.secondary, let backgroundColor = colors?.background else { return }

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [primaryColor.cgColor, secondaryColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.frame = view.bounds
        gradientLayer.cornerRadius = 10
        view.layer.insertSublayer(gradientLayer, at: 0)

        let finalColor: UIColor
        if !backgroundColor.isLight {
            finalColor = backgroundColor
        } else if !primaryColor.isLight {
            finalColor = primaryColor
        } else if !secondaryColor.isLight {
            finalColor = secondaryColor
        } else {
            finalColor = UIColor(named: "Background")!
        }
        
        // Get the current colors of the gradient layer
        guard let currentColors = gradientLayer.colors as? [CGColor] else { return }
        let animation = CABasicAnimation(keyPath: "colors")
        animation.fromValue = currentColors
        animation.toValue = [primaryColor.cgColor, finalColor.cgColor]
        animation.duration = 1
        gradientLayer.add(animation, forKey: "colorChange")
        gradientLayer.colors = [primaryColor.cgColor, finalColor.cgColor]
    }
}

