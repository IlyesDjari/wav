//
//  NameViewController.swift
//  wav
//
//  Created by Ilyes Djari on 08/05/2023.
//

import UIKit
import NotificationBannerSwift

class NameViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameTextField: UITextField! {
        didSet {
            nameTextField.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Add a tap gesture recognizer to the view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        // Resign the first responder status of the text field
        nameTextField.resignFirstResponder()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Resign the first responder status of the text field
        textField.resignFirstResponder()
        // Return `true` to indicate that the text field should process the "return" key
        return true
    }

    @IBAction func continueTapped(_ sender: Any) {
        guard let name = nameTextField.text, !name.isEmpty else {
            let banner = StatusBarNotificationBanner(title: "Please enter your name", style: .danger)
            banner.show()
            return
        }
        
        createUser(userName: name) { result in
            switch result {
            case .success(let userID):
                print("User created with ID: \(userID)")
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "NameToHomeSegue", sender: self)
                }
            case .failure(let error):
                print("Failed to create user: \(error)")
                DispatchQueue.main.async {
                    let banner = StatusBarNotificationBanner(title: "Failed to create user", style: .danger)
                    banner.show()
                }
            }
        }
    }
}
