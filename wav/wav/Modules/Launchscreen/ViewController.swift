//
//  ViewController.swift
//  wav
//
//  Created by Ilyes Djari on 02/05/2023.
//

import UIKit
import MusicKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        checkAuthorizationStatus()
    }
    
    private func checkAuthorizationStatus() {
        let segueIdentifier = MusicAuthorization.currentStatus == .authorized ? "LoginSegue" : "LoginSegue"
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: segueIdentifier, sender: self)
        }
    }
}
