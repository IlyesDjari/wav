//
//  ProfileViewController.swift
//  wav
//
//  Created by Ilyes Djari on 03/06/2023.
//

import UIKit

class ProfileViewController: UIViewController, UITextFieldDelegate {

    // Outlets
    @IBOutlet weak var username: UITextField! {
        didSet {
            username.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
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

    @objc private func handleTap() {
        view.endEditing(true)
        updateUsername()
    }

    private func updateUsername() {
        if let updatedText = username.text {
            print("Updated username: \(updatedText)")
            updateUsernameInFirestore(newUsername: updatedText) { result in
                switch result {
                case .success:
                    print("Username updated in Firestore")
                case .failure(let error):
                    print("Error updating username in Firestore: \(error)")
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == username {
            textField.resignFirstResponder()
            updateUsername()
            return false
        }
        return true
    }

}

