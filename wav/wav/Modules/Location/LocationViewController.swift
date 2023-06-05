//
//  LocationViewController.swift
//  wav
//
//  Created by Ilyes Djari on 09/05/2023.
//

import UIKit
import CoreData
import CoreLocation
import NotificationBannerSwift

class LocationViewController: UIViewController, CLLocationManagerDelegate {

    // Outlets
    @IBOutlet weak var greetingLabel: UILabel!

    // Properties
    var username: String?
    let locationManager = CLLocationManager()
    let activityIndicator = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserData()
        configureUI()
        locationManager.delegate = self
    }
    private func fetchUserData() {
        activityIndicator.startAnimating()
        Task {
            getUserFavoriteGenre { genre in
                if let favoriteGenre = genre {
                    addUserFavoriteGenre(genre: favoriteGenre) { result in
                        switch result {
                        case .success:
                            print("Favorite genre added successfully.")
                        case .failure(let error):
                            NotificationBanner.showErrorBanner(title: "Error", subtitle: "Error adding favorite genre: \(error.localizedDescription)")
                        }
                    }
                } else {
                    print("Unable to retrieve user's favorite genre.")
                }
            }
            getUserFavoriteSong { favoriteSong in
                if let song = favoriteSong {
                    let id = song.playbackStoreID
                    addUserFavoriteSong(songID: id) { result in
                        switch result {
                        case .success:
                            print("Favorite song added successfully.")
                        case .failure(let error):
                            NotificationBanner.showErrorBanner(title: "Error", subtitle: "Error adding favorite genre: \(error.localizedDescription)")
                        }
                    }
                } else {
                    print("Unable to retrieve user's favorite song.")
                }
            }
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.checkLocationAuthorization()
            }
        }
    }

    func configureUI() {
        if let username = self.username {
            greetingLabel.text = "Hello, \(username)!"
        } else {
            greetingLabel.text = "Hello!"
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Retrieve the username from Core Data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        do {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
            let result = try context.fetch(request)
            if let user = result.first as? User {
                self.username = user.username ?? ""
                configureUI()
            }
        } catch {
            NotificationBanner.showErrorBanner(title: "Error", subtitle: "Error retrieving user from Core Data: \(error.localizedDescription)")

        }
    }

    @IBAction func grantLocation(_ sender: Any) {
        locationManager.requestAlwaysAuthorization()
    }

    // MARK: - CLLocationManagerDelegate methods

    func checkLocationAuthorization() {
        print("called")
        let locationManager = CLLocationManager()
        let authorizationStatus = locationManager.authorizationStatus
        switch authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            performSegue(withIdentifier: "locationToHomeSegue", sender: nil)
        case .denied:
            print("Location access denied")
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .restricted:
            print("Location access restricted")
        @unknown default:
            print("Unknown location access status")
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            performSegue(withIdentifier: "locationToHomeSegue", sender: nil)
        case .denied:
            print("Location access denied")
        case .notDetermined:
            print("Location access not determined")
        case .restricted:
            print("Location access restricted")
        @unknown default:
            print("Unknown location access status")
        }
    }
}
