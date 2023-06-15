//
//  LoginViewController.swift
//  wav
//
//  Created by Ilyes Djari on 02/05/2023.
//

import UIKit
import MusicKit
import StoreKit
import CoreData
import NotificationBannerSwift

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private func checkAuthorizationStatus() {
        if MusicAuthorization.currentStatus == .authorized {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                let context = appDelegate.persistentContainer.viewContext
                let request = NSFetchRequest<User>(entityName: "User")
                request.fetchLimit = 1
                do {
                    let users = try context.fetch(request)
                    if users.first != nil {
                        performSegue(withIdentifier: "LoginToHomeSegue", sender: self)
                    } else {
                        performSegue(withIdentifier: "LoginToNameSegue", sender: self)
                    }
                } catch {
                    NotificationBanner.showErrorBanner(title: "Error", subtitle: "Failed to fetch users: \(error)")
                }
            }
        }
    }

    @IBAction func loginButton(_ sender: Any) {
        Task {
            let authorizationStatus = await MusicAuthorization.request()
            switch authorizationStatus {
            case .authorized:
                checkAuthorizationStatus()
            case .denied:
                print("User has denied access to Apple Music")
            case .notDetermined:
                print("Authorization status not determined")
            case .restricted:
                print("User is restricted from accessing Apple Music")
            @unknown default:
                print("Unknown authorization status")
            }
        }
    }

    @IBAction func notSubscribed(_ sender: Any) {
        if let appMusicURL = URL(string: "music://") {
            UIApplication.shared.open(appMusicURL, options: [:], completionHandler: nil)
        } else {
            print("Unable to open Apple Music app.")
        }
    }
}
