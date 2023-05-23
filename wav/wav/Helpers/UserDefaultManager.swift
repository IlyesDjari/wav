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
}
