//
//  getSongInfo.swift
//  wav
//
//  Created by Ilyes Djari on 17/05/2023.
//

import Foundation
import MusadoraKit
import UIKit

extension LiveSessionPlayerViewController {
    
    internal func getSongInfo(songID: String) {
        Task {
            do {
                let song = try await MCatalog.song(id: MusicItemID(rawValue: songID))
                if let artworkURL = song.artwork?.url(width: 200, height: 200) {
                    let data = try Data(contentsOf: artworkURL)
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            updateBackgroundColor(from: image, in: self.view)
                        }
                    }
                }
            } catch {
                print("Error retrieving song or loading image: \(error)")
            }
        }
    }
}
