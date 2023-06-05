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
    private let liveSessionListeningKey = "liveSessionListening"
    private let discoverabilityKey = "discoverabilityStatus"

    func saveSharePlayStatus(status: Bool) {
        UserDefaults.standard.set(status, forKey: sharePlayKey)
    }

    func getSharePlayStatus() -> Bool {
        return UserDefaults.standard.bool(forKey: sharePlayKey)
    }

    func setLiveSessionListening(_ listening: Bool) {
        UserDefaults.standard.set(listening, forKey: liveSessionListeningKey)
    }

    func isLiveSessionListening() -> Bool {
        return UserDefaults.standard.bool(forKey: liveSessionListeningKey)
    }

    func saveDiscoverabilityStatus(status: Bool) {
        UserDefaults.standard.set(status, forKey: discoverabilityKey)
    }

    func getDiscoverabilityStatus() -> Bool {
        if UserDefaults.standard.object(forKey: discoverabilityKey) == nil {
            saveDiscoverabilityStatus(status: true)
            return true
        } else {
            return UserDefaults.standard.bool(forKey: discoverabilityKey)
        }
    }
}
