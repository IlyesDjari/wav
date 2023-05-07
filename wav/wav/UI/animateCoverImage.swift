//
//  animateCoverImage.swift
//  wav
//
//  Created by Ilyes Djari on 07/05/2023.
//

import UIKit

public func animateCoverImage(_ cover: UIImageView, isNext: Bool) {
    let animationOptions: UIView.AnimationOptions = isNext ? .transitionFlipFromRight : .transitionFlipFromLeft
    UIView.transition(with: cover, duration: 0.5, options: animationOptions, animations: nil, completion: nil)
}
