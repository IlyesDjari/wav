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

        let animation = CABasicAnimation(keyPath: "colors")
        animation.fromValue = gradientLayer.colors
        animation.toValue = [finalColor.cgColor, finalColor.cgColor]
        animation.duration = 3.0
        gradientLayer.add(animation, forKey: "colorChange")

        let autoreverseAnimation = CABasicAnimation(keyPath: "colors")
        autoreverseAnimation.fromValue = [finalColor.cgColor, finalColor.cgColor]
        autoreverseAnimation.toValue = gradientLayer.colors
        autoreverseAnimation.duration = 20.0
        autoreverseAnimation.autoreverses = true
        autoreverseAnimation.repeatCount = Float.infinity
        gradientLayer.add(autoreverseAnimation, forKey: "colorChangeAutoreverse")
    }
}
