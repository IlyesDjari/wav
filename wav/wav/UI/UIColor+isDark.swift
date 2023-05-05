//
//  UIColor+isDark.swift
//  wav
//
//  Created by Ilyes Djari on 04/05/2023.
//

import Foundation
import UIKit

extension UIColor {
    var isLight: Bool {
        guard let components = cgColor.components, components.count >= 3 else {
            return false
        }
        let brightness = ((0.299 * components[0]) + (0.587 * components[1]) + (0.114 * components[2]))
        return brightness > 0.5
    }
}
