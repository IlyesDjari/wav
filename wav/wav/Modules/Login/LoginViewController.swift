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

class LoginViewController: UIViewController, SKCloudServiceSetupViewControllerDelegate {

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
                setupSubscribtion()
            case .notDetermined:
                setupSubscribtion()
            case .restricted:
                setupSubscribtion()
            @unknown default:
                setupSubscribtion()
            }
        }
    }

    @IBAction func notSubscribed(_ sender: Any) {
       setupSubscribtion()
    }

    func setupSubscribtion() {
        let options: [SKCloudServiceSetupOptionsKey: Any] = [
                .action: SKCloudServiceSetupAction.subscribe,
                .messageIdentifier: SKCloudServiceSetupMessageIdentifier.addMusic]
        let controller = SKCloudServiceSetupViewController()
        controller.delegate = self
        controller.load(options: options) { [weak self] (result: Bool, error: Error?) in
            guard error == nil else { return }
            if result {
                self?.present(controller, animated: true, completion: nil)
            }
        }
    }
}
