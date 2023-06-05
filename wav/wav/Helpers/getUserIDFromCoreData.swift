//
//  getUserIDFromCoreData.swift
//  wav
//
//  Created by Ilyes Djari on 09/05/2023.
//

import Foundation
import CoreData
import UIKit

internal func getUserIDFromCoreData() -> String? {
    // Access the Core Data context
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
    let context = appDelegate.persistentContainer.viewContext

    // Fetch the user ID
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")

    do {
        let result = try context.fetch(fetchRequest)
        if let user = result.first as? User {
            return user.id
        }
    } catch {
        print("Failed to fetch user ID from Core Data: \(error)")
    }

    return nil
}
