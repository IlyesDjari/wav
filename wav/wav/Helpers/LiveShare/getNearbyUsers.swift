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
        let error = NSError(
            domain: "ilyesdjari.wav",
            code: 404,
            userInfo: [NSLocalizedDescriptionKey: "User not found in Core Data"]
        )
        completion(.failure(error))
        return
    }

    fetchUserLocation(userID: userID) { result in
        switch result {
        case .success(let currentUserLocation):
            queryNearbyUsers(currentUserLocation: currentUserLocation, userID: userID, completion: completion)

        case .failure(let error):
            completion(.failure(error))
        }
    }
}

private func fetchUserLocation(userID: String, completion: @escaping (Result<GeoPoint, Error>) -> Void) {
    let usersRef = Firestore.firestore().collection("Users")
    let userDocRef = usersRef.document(userID)
    userDocRef.getDocument { (document, error) in
        if let error = error {
            completion(.failure(error))
        } else if let document = document, document.exists,
            let currentUserLocation = document.data()?["location"] as? GeoPoint {
            completion(.success(currentUserLocation))
        } else {
            let error = NSError(
                domain: "ilyesdjari.wav",
                code: 404,
                userInfo: [NSLocalizedDescriptionKey: "User document not found or missing location field"]
            )
            completion(.failure(error))
        }
    }
}

private func queryNearbyUsers(
    currentUserLocation: GeoPoint,
    userID: String,
    completion: @escaping (Result<[NearbyUser], Error>) -> Void
) {
    let usersRef = Firestore.firestore().collection("Users")

    usersRef.getDocuments { (snapshot, error) in
        if let error {
            completion(.failure(error))
            return
        } else if let snapshot {
            var nearbyUsers: [NearbyUser] = []

            for document in snapshot.documents {
                guard let otherUserLocation = document.data()["location"] as? GeoPoint,
                    let otherUserID = document.documentID as String?,
                    let otherSongID = document.data()["currentSong"] as? String,
                    let otherLongitude = otherUserLocation.longitude  as Double?,
                    let otherLatitude = otherUserLocation.latitude as Double?,
                    let otherUsername = document.data()["username"] as? String,
                    let otherSong = document.data()["favoriteSong"] as? String,
                    let otherGenre = document.data()["favoriteGenre"] as? String,
                    let discover = document.data()["discover"] as? Bool
                else {
                        continue
                }
                if otherSongID.isEmpty || otherUserID == userID {
                    continue
                }
                let distance = calculateDistance(currentUserLocation, otherUserLocation)
                if distance <= 500 {
                    let nearbyUser = NearbyUser(
                        songID: otherSongID,
                        longitude: otherLongitude,
                        latitude: otherLatitude,
                        username: otherUsername,
                        favoriteGenre: otherGenre,
                        favoriteSong: otherSong,
                        discover: discover,
                        id: otherUserID
                    )
                    nearbyUsers.append(nearbyUser)
                }
            }

            completion(.success(nearbyUsers))
        } else {
            let error = NSError(
                domain: "ilyesdjari.wav",
                code: 500,
                userInfo: [NSLocalizedDescriptionKey: "Snapshot is nil"]
            )
            completion(.failure(error))
        }
    }
}

func calculateDistance(_ location1: GeoPoint, _ location2: GeoPoint) -> Double {
    let coordinate1 = CLLocation(latitude: location1.latitude, longitude: location1.longitude)
    let coordinate2 = CLLocation(latitude: location2.latitude, longitude: location2.longitude)
    return coordinate1.distance(from: coordinate2)
}
