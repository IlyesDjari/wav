//
//  LocationViewController+getUserFavoriteGenre.swift
//  wav
//
//  Created by Ilyes Djari on 16/05/2023.
//

import Foundation
import MediaPlayer

extension LocationViewController {
    func getUserFavoriteGenre(completion: @escaping (String?) -> Void) {
        MPMediaLibrary.requestAuthorization { status in
            guard status == .authorized else {
                completion(nil)
                return
            }
            
            let query = MPMediaQuery.songs()
            guard let songs = query.items else {
                completion(nil)
                return
            }
            
            var genreCounts: [String: Int] = [:]
            
            for song in songs {
                if let genre = song.genre {
                    genreCounts[genre] = (genreCounts[genre] ?? 0) + 1
                }
            }
            
            let favoriteGenre = genreCounts.max(by: { $0.value < $1.value })?.key
            completion(favoriteGenre)
        }
    }
}
