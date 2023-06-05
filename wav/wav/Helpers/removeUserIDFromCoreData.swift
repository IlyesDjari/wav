//
//  removeUserIDFromCoreData.swift
//  wav
//
//  Created by Ilyes Djari on 05/06/2023.
//

import Foundation
import CoreData
import UIKit

func removeUserIDFromCoreData() {
    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        do {
            let users = try context.fetch(fetchRequest)
            if let user = users.first {
                context.delete(user)
                try context.save()
            }
        } catch {
            print("Error removing user ID from Core Data: \(error)")
        }
    }
}
