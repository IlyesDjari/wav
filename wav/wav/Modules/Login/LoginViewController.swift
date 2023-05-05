//
//  LoginViewController.swift
//  wav
//
//  Created by Ilyes Djari on 02/05/2023.
//

import UIKit
import MusicKit
import StoreKit


class LoginViewController: UIViewController {

    @IBAction func LoginButton(_ sender: Any) {
        Task {
            let authorizationStatus = await MusicAuthorization.request()
            switch authorizationStatus {
            case .authorized:
                print("User is connected to Apple Music")
                performSegue(withIdentifier: "LoginToHomeSegue", sender: self)
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

    @IBAction func NotSubscribed(_ sender: Any) {
        let appleMusicAppStoreURL = URL(string: "https://apps.apple.com/app/apple-music/id1108187390")!
        UIApplication.shared.open(appleMusicAppStoreURL, options: [:], completionHandler: nil)
    }
}
