//
//  animateImageTransition.swift
//  wav
//
//  Created by Ilyes Djari on 08/05/2023.
//

import Foundation
import UIKit
import Pulsator

extension UIImageView {
    func animateImageTransition(to newImage: UIImage?, withBounce shouldBounce: Bool, view: UIView? = nil) {
        guard let newImage else { return }

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
        if let pulsatorView = view {
            let pulsator = Pulsator()
            pulsator.radius = 60
            pulsator.backgroundColor = UIColor(named: "Purple")?.cgColor
            pulsator.position = CGPoint(x: pulsatorView.bounds.midX, y: pulsatorView.bounds.midY - 10)
            pulsatorView.layer.addSublayer(pulsator)
            pulsator.animationDuration = 3
            pulsator.repeatCount = 1
            pulsator.start()
            DispatchQueue.main.asyncAfter(deadline: .now() + pulsator.animationDuration) {
                pulsator.stop()
                pulsator.removeFromSuperlayer()
            }
        }
    }

    func bounce() {
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1, 1.2, 0.9, 1.1, 1]
        bounceAnimation.duration = 0.4
        bounceAnimation.calculationMode = .cubic
        layer.add(bounceAnimation, forKey: nil)
    }
}
