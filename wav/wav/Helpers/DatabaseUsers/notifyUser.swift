//
//  notifyUser.swift
//  wav
//
//  Created by Ilyes Djari on 06/06/2023.
//

import Foundation
import FirebaseFirestore

func updateNotificationField(withUserID userID: String) {
    let usersRef = Firestore.firestore().collection("Users")
    let userDocRef = usersRef.document(userID)
    userDocRef.getDocument { (document, error) in
        if let error {
            print("Error fetching document: \(error)")
        } else if let document = document, document.exists {
            userDocRef.updateData(["notification": "Someone is trying to find you, look around 👀"]) { error in
                if let error {
                    print("Error updating notification field: \(error)")
                } else {
                    print("Notification field updated successfully")
                }
            }
        } else {
            print("User document not found")
        }
    }
}
