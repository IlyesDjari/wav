//
//  animateImageTransition.swift
//  wav
//
//  Created by Ilyes Djari on 08/05/2023.
//

import Foundation
import UIKit

extension UIImageView {
    func animateImageTransition(to newImage: UIImage?, withBounce shouldBounce: Bool) {
        guard let newImage = newImage else { return }

        UIView.transition(with: self,
                          duration: 0.3,
                          options: [.transitionCrossDissolve],
                          animations: {
                              self.image = newImage
                          },
                          completion: { finished in
                              if shouldBounce && finished {
                                  self.bounce()
                              }
                          })
    }

    func bounce() {
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1, 1.2, 0.9, 1.1, 1]
        bounceAnimation.duration = 0.4
        bounceAnimation.calculationMode = .cubic
        layer.add(bounceAnimation, forKey: nil)
    }
}
