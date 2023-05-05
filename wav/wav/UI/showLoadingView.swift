//
//  showLoadingView.swift
//  wav
//
//  Created by Ilyes Djari on 05/05/2023.
//

import Foundation
import UIKit

func showLoadingView(on view: UIView) -> UIView {
    let loadingView = UIView(frame: view.bounds)
    loadingView.backgroundColor = .black
    let activityIndicator = UIActivityIndicatorView(style: .large)
    activityIndicator.center = loadingView.center
    loadingView.addSubview(activityIndicator)
    activityIndicator.startAnimating()
    view.addSubview(loadingView)
    view.isUserInteractionEnabled = false
    return loadingView
}
