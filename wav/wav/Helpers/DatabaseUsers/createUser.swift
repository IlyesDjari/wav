//
//  createUser.swift
//  wav
//
//  Created by Ilyes Djari on 08/05/2023.
//

import Foundation
import UIKit
import FirebaseFirestore
import CoreData

func createUser(userName: String, completion: @escaping (Result<String, Error>) -> Void) {
    let db = Firestore.firestore()
    // Create a new document in the "Users" collection with a unique ID
    var ref: DocumentReference?
    ref = db.collection("Users").addDocument(data: [
        "username": userName,
        "createdAt": FieldValue.serverTimestamp()
    ]) { error in
        if let error = error {
            completion(.failure(error))
        } else {
            completion(.success(ref!.documentID))
        }
    }
    // Save the ID and username in Core Data
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        // Handle the case when the app delegate cannot be cast properly
        fatalError("AppDelegate not found")
    }
    let context = appDelegate.persistentContainer.viewContext
    let user = User(context: context)
    user.id = ref!.documentID
    user.username = userName
    do {
        try context.save()
    } catch {
        completion(.failure(error))
    }
}
