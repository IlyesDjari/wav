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
        // Set the maximum track tint color to a light gray color
        slider.maximumTrackTintColor = UIColor(white: 0.8, alpha: 1.0)
        // Set the background color of the slider to clear
        slider.backgroundColor = UIColor.clear
    }
}
