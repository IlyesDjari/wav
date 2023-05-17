//
//  updateLocationDB.swift
//  wav
//
//  Created by Ilyes Djari on 17/05/2023.
//

import Foundation
import FirebaseFirestore
import CoreLocation

public func updateLocationDB(location: CLLocation?, completion: @escaping (Result<Void, Error>) -> Void) {
    guard let userID = getUserIDFromCoreData() else {
        completion(.failure(NSError(domain: "ilyesdjari.wav", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not found in Core Data"])))
        return
    }
    
    guard let location = location else {
        completion(.failure(NSError(domain: "ilyesdjari.wav", code: 404, userInfo: [NSLocalizedDescriptionKey: "No location available"])))
        return
    }
    
    let db = Firestore.firestore()
    let geoPoint = GeoPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    db.collection("Users").document(userID).updateData([
        "location": geoPoint
    ]) { err in
        DispatchQueue.main.async {
            if let err = err {
                print("Error updating location: \(err)")
                completion(.failure(err))
            } else {
                print("Location successfully updated")
                completion(.success(()))
            }
        }
    }
}
