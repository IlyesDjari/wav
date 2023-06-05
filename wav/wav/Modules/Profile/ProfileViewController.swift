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
    @IBOutlet weak var turnOnDiscoverability: UIView!
    @IBOutlet weak var turnOffDiscoverability: UIView!

    @IBOutlet weak var username: UITextField! {
        didSet {
            username.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUserData()
        discoverabilityStatus()
    }

    private func discoverabilityStatus() {
        let discoverabilityStatus = UserDefaultsManager.shared.getDiscoverabilityStatus()
        let onColor = UIColor(named: "Purple")
        let offColor = UIColor(named: "defaultPlayerBackground")
        print("Discoverability status: \(discoverabilityStatus)")
        UIView.animate(withDuration: 0.3) {
            self.turnOnDiscoverability.backgroundColor = discoverabilityStatus ? onColor : offColor
            self.turnOffDiscoverability.backgroundColor = discoverabilityStatus ? offColor : onColor
        }
    }

    @IBAction func tapOn(_ sender: Any) {
        Task {
            UserDefaultsManager.shared.saveDiscoverabilityStatus(status: true)
            discoverabilityStatus()
        }
    }

    @IBAction func tapOff(_ sender: Any) {
        Task {
            UserDefaultsManager.shared.saveDiscoverabilityStatus(status: false)
            discoverabilityStatus()
        }
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
                NotificationBanner.showErrorBanner(title: "Error", subtitle: "Error retrieving username: \(error)")

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
                    NotificationBanner.showErrorBanner(title: "Error", subtitle: "Error updating username in Firestore: \(error)")

                }
            }
        }
    }

    private func showSuccessNotification() {
        let banner = NotificationBanner(title: "Success", subtitle: "Username updated", style: .success)
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

    private func performAccountRemoval() {
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
                NotificationBanner.showErrorBanner(title: "Error", subtitle: "Error removing account: \(error)")

            }
        }
    }

    @IBAction func removeAccount(_ sender: Any) {
        let alert = UIAlertController(title: "Confirmation", message: "Are you sure you want to remove your account?", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Remove", style: .destructive) { [weak self] (_) in
            self?.performAccountRemoval()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}
