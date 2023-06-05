//
//  addGenre.swift
//  wav
//
//  Created by Ilyes Djari on 16/05/2023.
//

import Foundation
import FirebaseFirestore

func addUserFavoriteGenre(genre: String, completion: @escaping (Result<Void, Error>) -> Void) {

    DispatchQueue.main.async {
        guard let userID = getUserIDFromCoreData() else {
            completion(.failure(NSError(domain: "ilyesdjari.wav", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not found in Core Data"])))
            return
        }
        let db = Firestore.firestore()
        let usersRef = db.collection("Users")

        usersRef.document(userID).setData(["favoriteGenre": genre], merge: true) { error in
            if let error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
