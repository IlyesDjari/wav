//
//  ViewController.swift
//  wav
//
//  Created by Ilyes Djari on 02/05/2023.
//

import UIKit
import MusicKit
import CoreData

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        checkAuthorizationStatus()
    }
    
    private func checkAuthorizationStatus() {
        let segueIdentifier: String
        switch MusicAuthorization.currentStatus {
        case .authorized:
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
            do {
                let results = try context.fetch(fetchRequest)
                if let user = results.first, let username = user.username, !username.isEmpty {
                    segueIdentifier = "HomeSegue"
                } else {
                    segueIdentifier = "LoginSegue"
                }
            } catch {
                segueIdentifier = "LoginSegue"
            }
        default:
            segueIdentifier = "LoginSegue"
        }
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: segueIdentifier, sender: self)
        }
    }
}
