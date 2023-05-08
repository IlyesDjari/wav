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
    var ref: DocumentReference? = nil
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
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let user = User(context: context)
    user.id = ref!.documentID
    user.username = userName
    do {
        try context.save()
    } catch {
        completion(.failure(error))
    }
}
