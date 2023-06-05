//
//  errorNotification.swift
//  wav
//
//  Created by Ilyes Djari on 05/06/2023.
//

import Foundation
import NotificationBannerSwift

extension NotificationBanner {
    static func showErrorBanner(title: String, subtitle: String? = nil) {
        let banner = NotificationBanner(title: title, subtitle: subtitle, style: .danger)
        banner.show()
        banner.autoDismiss = true
    }
}
