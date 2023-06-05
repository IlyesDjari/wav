//
//  startLiveShareSession.swift
//  wav
//
//  Created by Ilyes Djari on 09/05/2023.
//

import Foundation
import FirebaseFirestore
import CoreLocation

internal func startLiveShareSession(
    songID: String,
    completion: @escaping (Result<Void, Error>) -> Void
) {
    guard let userID = getUserIDFromCoreData() else {
        let error = NSError(
            domain: "ilyesdjari.wav",
            code: 404,
            userInfo: [NSLocalizedDescriptionKey: "User not found in Core Data"]
        )
        completion(.failure(error))
        return
    }

    fetchUserFromFirestore(userID: userID) { result in
        switch result {
        case .success(let document):
            guard let location = getUserLocation() else {
                completion(.failure(NSError(
                    domain: "ilyesdjari.wav",
                    code: 404,
                    userInfo: [NSLocalizedDescriptionKey: "User not found in Core Data"])))
                return
            }

            handleFirestoreDocument(document, location: location, songID: songID, completion: completion)

        case .failure(let error):
            completion(.failure(error))
        }
    }
}

private func fetchUserFromFirestore(userID: String, completion: @escaping (Result<DocumentSnapshot, Error>) -> Void) {
    let usersRef = Firestore.firestore().collection("Users")
    let userDocRef = usersRef.document(userID)

    userDocRef.getDocument { (documentSnapshot, error) in
        if let error = error {
            completion(.failure(error))
        } else if let document = documentSnapshot, document.exists {
            completion(.success(document))
        } else {
            let error = NSError(
                domain: "ilyesdjari.wav",
                code: 404,
                userInfo: [NSLocalizedDescriptionKey: "User not found in Firestore"]
            )
            completion(.failure(error))
        }
    }
}

private func getUserLocation() -> CLLocation? {
    let locationManager = CLLocationManager()
    locationManager.requestWhenInUseAuthorization()
    locationManager.startUpdatingLocation()
    return locationManager.location
}

private func handleFirestoreDocument(
    _ document: DocumentSnapshot,
    location: CLLocation,
    songID: String,
    completion: @escaping (Result<Void, Error>) -> Void
) {
    let userDocRef = document.reference

    if document.data()?["location"] == nil {
        let geoPoint = GeoPoint(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )
        updateUserDocument(userDocRef, data: ["location": geoPoint], completion: completion)
    } else {
        let existingGeoPoint = document.data()?["location"] as? GeoPoint
        let newGeoPoint = GeoPoint(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )

        if existingGeoPoint == newGeoPoint {
            print("User location is the same as before: \(location)")
            completion(.success(()))
        } else {
            updateUserDocument(userDocRef, data: ["location": newGeoPoint], completion: completion)
        }
    }
    updateUserDocument(userDocRef, data: ["currentSong": songID], completion: completion)
}

private func updateUserDocument(
    _ documentRef: DocumentReference,
    data: [String: Any],
    completion: @escaping (Result<Void, Error>) -> Void
) {
    documentRef.updateData(data) { error in
        if let error = error {
            completion(.failure(error))
        } else {
            completion(.success(()))
        }
    }
}
