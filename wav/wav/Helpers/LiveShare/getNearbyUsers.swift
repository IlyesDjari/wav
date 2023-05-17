//
//  getNearbyUsers.swift
//  wav
//
//  Created by Ilyes Djari on 15/05/2023.
//

import Foundation
import FirebaseFirestore
import CoreLocation

func getNearbyUsers(completion: @escaping (Result<[NearbyUser], Error>) -> Void) {
    guard let userID = getUserIDFromCoreData() else {
        completion(.failure(NSError(domain: "ilyesdjari.wav", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not found in Core Data"])))
        return
    }
    
    let db = Firestore.firestore()
    let usersRef = db.collection("Users")
    
    // Retrieve current user's location
    usersRef.document(userID).getDocument { (document, error) in
        if let error = error {
            completion(.failure(error))
            return
        }
        
        guard let document = document,
              document.exists,
              let currentUserLocation = document.data()?["location"] as? GeoPoint else {
            completion(.failure(NSError(domain: "ilyesdjari.wav", code: 404, userInfo: [NSLocalizedDescriptionKey: "User document not found or missing location field"])))
            return
        }
        
        // Query for users within the 500-meter radius
        usersRef.getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let snapshot = snapshot else {
                completion(.failure(NSError(domain: "ilyesdjari.wav", code: 500, userInfo: [NSLocalizedDescriptionKey: "Snapshot is nil"])))
                return
            }
            
            var nearbyUsers: [NearbyUser] = []
            
            for document in snapshot.documents {
                guard let otherUserLocation = document.data()["location"] as? GeoPoint else {
                    continue
                }
                let otherUserID = document.documentID
                let otherSongID = document.data()["currentSong"] as? String ?? ""
                let otherLongitude = otherUserLocation.longitude
                let otherLatitude = otherUserLocation.latitude
                let otherUsername = document.data()["username"] as? String ?? ""
                let otherSong = document.data()["favoriteSong"] as? String ?? ""
                let otherGenre = document.data()["favoriteGenre"] as? String ?? ""
                if otherUserID != userID {
                    // Calculate the distance between the current user's location and other users' location
                    let distance = calculateDistance(currentUserLocation, otherUserLocation)
                    if distance <= 500 {
                        let nearbyUser = NearbyUser(songID: otherSongID, longitude: otherLongitude, latitude: otherLatitude, username: otherUsername, favoriteGenre: otherGenre, favoriteSong: otherSong, id: otherUserID)
                        nearbyUsers.append(nearbyUser)
                    }
                }
            }
            completion(.success(nearbyUsers))
        }
    }
}

// Function to calculate the distance between two GeoPoints
func calculateDistance(_ location1: GeoPoint, _ location2: GeoPoint) -> Double {
    let coordinate1 = CLLocation(latitude: location1.latitude, longitude: location1.longitude)
    let coordinate2 = CLLocation(latitude: location2.latitude, longitude: location2.longitude)
    return coordinate1.distance(from: coordinate2)
}
