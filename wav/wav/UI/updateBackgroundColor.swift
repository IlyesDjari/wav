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
        guard let view = view, let backgroundColor = colors?.background else { return }
        
        let background = backgroundColor.isLight ? UIColor.black : backgroundColor
        UIView.animate(withDuration: 1) {
            view.backgroundColor = background
        }
    }
}
