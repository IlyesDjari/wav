//
//  startLiveShareSession.swift
//  wav
//
//  Created by Ilyes Djari on 09/05/2023.
//

import Foundation
import FirebaseFirestore
import CoreLocation

internal func startLiveShareSession(songID: String, completion: @escaping (Result<Void, Error>) -> Void) {
    // Access Core Data to fetch the user ID
    guard let userID = getUserIDFromCoreData() else {
        completion(.failure(NSError(domain: "ilyesdjari.wav", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not found in Core Data"])))
        return
    }

    // Access Firestore to find the correct user
    let db = Firestore.firestore()
    let usersRef = db.collection("Users")
    let userDocRef = usersRef.document(userID)

    // Get user location with CLLocationManager
    let locationManager = CLLocationManager()
    locationManager.requestWhenInUseAuthorization()
    locationManager.startUpdatingLocation()
    guard let location = locationManager.location else {
        print("Could not get user location")
        return
    }

    userDocRef.getDocument { (documentSnapshot, error) in
        if let error = error {
            completion(.failure(error))
        } else {
            guard let document = documentSnapshot, document.exists else {
                completion(.failure(NSError(domain: "ilyesdjari.wav", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not found in Firestore"])))
                return
            }

            // Check if the location field exists in the document
            if document.data()?["location"] == nil {
                // If it does not exist, create a new GeoPoint object and add it to the location field
                let geoPoint = GeoPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                userDocRef.updateData(["location": geoPoint]) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        print("User document updated with new location: \(location)")
                    }
                }
            } else {
                // If it exists, update the existing GeoPoint object with the user's new location
                let existingGeoPoint = document.data()?["location"] as? GeoPoint
                let newGeoPoint = GeoPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                if existingGeoPoint == newGeoPoint {
                    print("User location is the same as before: \(location)")
                } else {
                    userDocRef.updateData(["location": newGeoPoint]) { error in
                        if let error = error {
                            completion(.failure(error))
                        } else {
                            print("User document updated with new location: \(location)")
                        }
                    }
                }
            }

            // Update the currentSong field with the new songID
            userDocRef.updateData(["currentSong": songID]) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    print("User document updated with new songID: \(songID)")
                    completion(.success(()))
                }
            }
        }
    }
}
