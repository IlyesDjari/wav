//
//  LocationViewController+getUserFavoriteSong.swift
//  wav
//
//  Created by Ilyes Djari on 16/05/2023.
//

import Foundation
import MediaPlayer

extension LocationViewController {
    func getUserFavoriteSong(completion: @escaping (MPMediaItem?) -> Void) {
        MPMediaLibrary.requestAuthorization { status in
            guard status == .authorized else {
                completion(nil)
                return
            }

            let query = MPMediaQuery.songs()
            query.addFilterPredicate(
                MPMediaPropertyPredicate(
                    value: NSNumber(value: true),
                    forProperty: MPMediaItemPropertyIsCloudItem))
            query.addFilterPredicate(
                MPMediaPropertyPredicate(
                    value: NSNumber(value: false),
                    forProperty: MPMediaItemPropertyIsExplicit))
            if let items = query.items {
                let sortedItems = items.sorted { $0.playCount > $1.playCount }
                completion(sortedItems.first)
            } else {
                completion(nil)
            }
        }
    }
}
