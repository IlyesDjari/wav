//
//  getUser.swift
//  wav
//
//  Created by Ilyes Djari on 05/06/2023.
//

import Foundation

import Foundation
import UIKit
import FirebaseFirestore
import CoreData


func getUser(completion: @escaping (Result<String, Error>) -> Void) {
    DispatchQueue.main.async {
        guard let userID = getUserIDFromCoreData() else {
            completion(.failure(NSError(domain: "ilyesdjari.wav", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not found in Core Data"])))
            return
        }
        let db = Firestore.firestore()
        let usersRef = db.collection("Users")
    
        usersRef.document(userID).getDocument { (document, error) in
            if let error = error {
                completion(.failure(error))
            } else if let document = document, document.exists {
                if let username = document.data()?["username"] as? String {
                    completion(.success(username))
                } else {
                    completion(.failure(NSError(domain: "ilyesdjari.wav", code: 404, userInfo: [NSLocalizedDescriptionKey: "Username not found in Firestore"])))
                }
            } else {
                completion(.failure(NSError(domain: "ilyesdjari.wav", code: 404, userInfo: [NSLocalizedDescriptionKey: "User document not found in Firestore"])))
            }
        }
    }
}
