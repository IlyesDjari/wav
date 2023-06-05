//
//  removeUser.swift
//  wav
//
//  Created by Ilyes Djari on 05/06/2023.
//

import Foundation
import FirebaseFirestore

func removeUser(completion: @escaping (Result<Void, Error>) -> Void) {
    DispatchQueue.main.async {
        guard let userID = getUserIDFromCoreData() else {
            completion(
                    .failure(
                    NSError(
                        domain: "ilyesdjari.wav",
                        code: 404,
                        userInfo: [NSLocalizedDescriptionKey: "User not found in Core Data"])))
            return
        }
        let dataBase = Firestore.firestore()
        let usersRef = dataBase.collection("Users")

        usersRef.document(userID).delete { error in
            if let error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
