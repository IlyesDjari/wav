//
//  loadingIndicator.swift
//  wav
//
//  Created by Ilyes Djari on 09/05/2023.
//

import Foundation
import UIKit

class LoadingIndicatorView: UIView {

    private let activityIndicator = UIActivityIndicatorView(style: .large)

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }

    private func configureView() {
        backgroundColor = .clear
        activityIndicator.color = .white
        activityIndicator.hidesWhenStopped = true
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    func show(on view: UIView) {
        frame = view.bounds
        view.addSubview(self)
        startLoading()
    }

    func hide() {
        stopLoading()
        removeFromSuperview()
    }

    private func startLoading() {
        activityIndicator.startAnimating()
    }

    private func stopLoading() {
        activityIndicator.stopAnimating()
    }
}
