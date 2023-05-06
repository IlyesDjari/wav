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
        UIView.animate(withDuration: 1) {
            view.backgroundColor = finalColor
        }
    }
}
