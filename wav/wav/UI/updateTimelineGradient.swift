//
//  updateTimelineGradient.swift
//  wav
//
//  Created by Ilyes Djari on 06/05/2023.
//

import Foundation
import UIKit

public func updateTimelineGradient(from image: UIImage?, in slider: UISlider) {
    guard let image = image else { return }
    
    // Get the primary color from the image
    image.getColors { [weak slider] colors in
        guard let slider = slider, let primaryColor = colors?.detail else { return }
        // Set the tint color for the slider thumb
        slider.tintColor = primaryColor
        // Set the maximum track tint color to a contrasting color
        let maxTrackContrastColor = contrastingColor(for: primaryColor)
        slider.maximumTrackTintColor = maxTrackContrastColor
        // Set the background color of the slider to clear
        slider.backgroundColor = UIColor.clear
    }
}

func contrastingColor(for color: UIColor) -> UIColor {
    var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
    color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    let brightness = (0.299 * red + 0.587 * green + 0.114 * blue)
    return brightness > 0.3 ? UIColor.black : UIColor.white
}
