//
//  stopLiveShareSession.swift
//  wav
//
//  Created by Ilyes Djari on 09/05/2023.
//

import Foundation
import FirebaseFirestore

internal func stopLiveShareSession(completion: @escaping (Result<Void, Error>) -> Void) {
    // Access Core Data to fetch the user ID
    guard let userID = getUserIDFromCoreData() else {
        completion(.failure(NSError(domain: "ilyesdjari.wav", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not found in Core Data"])))
        return
    }

    // Access Firestore to find the correct user
    let db = Firestore.firestore()
    let usersRef = db.collection("Users")
    let userDocRef = usersRef.document(userID)

    // Remove the currentSong field
    userDocRef.updateData(["currentSong": FieldValue.delete(), "location": FieldValue.delete()]) { error in
        if let error = error {
            completion(.failure(error))
        } else {
            print("User document updated with currentSong and location fields removed")
            completion(.success(()))
        }
    }
}
