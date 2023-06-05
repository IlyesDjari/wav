//
//  updateUsername.swift
//  wav
//
//  Created by Ilyes Djari on 05/06/2023.
//

import Foundation
import FirebaseFirestore

func updateUsernameInFirestore(newUsername: String, completion: @escaping (Result<Void, Error>) -> Void) {
    DispatchQueue.main.async {
        let dataBase = Firestore.firestore()
        guard let userID = getUserIDFromCoreData() else {
            completion(
                    .failure(
                    NSError(
                        domain: "ilyesdjari.wav",
                        code: 404, userInfo: [NSLocalizedDescriptionKey: "User not found in Core Data"])))
            return
        }
        let userRef = dataBase.collection("Users").document(userID)
        userRef.updateData(["username": newUsername]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
