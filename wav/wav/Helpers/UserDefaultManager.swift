//
//  UserDefaultManager.swift
//  wav
//
//  Created by Ilyes Djari on 09/05/2023.
//

import Foundation

struct UserDefaultsManager {
    static let shared = UserDefaultsManager()

    private let sharePlayKey = "sharePlayStatus"

    func saveSharePlayStatus(status: Bool) {
        UserDefaults.standard.set(status, forKey: sharePlayKey)
    }

    func getSharePlayStatus() -> Bool {
        return UserDefaults.standard.bool(forKey: sharePlayKey)
    }
}
