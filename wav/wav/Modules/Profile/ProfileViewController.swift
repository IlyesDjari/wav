//
//  ProfileViewController.swift
//  wav
//
//  Created by Ilyes Djari on 03/06/2023.
//

import UIKit
import MusicKit
import NotificationBannerSwift

class ProfileViewController: UIViewController, UITextFieldDelegate {

    // Outlets
    @IBOutlet weak var username: UITextField! {
        didSet {
            username.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUserData()
    }

    private func setUserData() {
        getUser { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let username):
                DispatchQueue.main.async {
                    self.username.text = username
                }
            case .failure(let error):
                print("Error retrieving username: \(error)")
            }
        }
    }


    private func updateUsername() {
        if let updatedText = username.text {
            print("Updated username: \(updatedText)")
            updateUsernameInFirestore(newUsername: updatedText) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success:
                    print("Username updated in Firestore")
                    self.showSuccessNotification()
                case .failure(let error):
                    print("Error updating username in Firestore: \(error)")
                    self.showErrorNotification()
                }
            }
        }
    }

    private func showSuccessNotification() {
        let banner = NotificationBanner(title: "Success", subtitle: "Username updated", style: .success)
        banner.show()
        banner.autoDismiss = true
    }

    private func showErrorNotification() {
        let banner = NotificationBanner(title: "Error", subtitle: "Failed to update username, try again", style: .danger)
        banner.show()
        banner.autoDismiss = true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == username {
            textField.resignFirstResponder()
            updateUsername()
            return false
        }
        return true
    }
    @IBAction func removeAccount(_ sender: Any) {
        removeUser { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                // Remove the user ID from Core Data
                removeUserIDFromCoreData()
                // Perform the segue
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "removedAccount", sender: nil)
                }
            case .failure(let error):
                let banner = NotificationBanner(title: "Error", subtitle: "Error removing account: \(error)", style: .danger)
                banner.show()
                banner.autoDismiss = true
            }
        }
    }
}
