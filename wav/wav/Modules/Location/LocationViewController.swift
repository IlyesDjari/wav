//
//  LocationViewController.swift
//  wav
//
//  Created by Ilyes Djari on 09/05/2023.
//

import UIKit
import CoreData
import CoreLocation

class LocationViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var greetingLabel: UILabel!
    var username: String?
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        locationManager.delegate = self
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
            print("Error retrieving user from Core Data: \(error.localizedDescription)")
        }
    }
    
    @IBAction func grantLocation(_ sender: Any) {
        locationManager.requestAlwaysAuthorization()
    }

    // MARK: - CLLocationManagerDelegate methods

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways:
            performSegue(withIdentifier: "locationToHomeSegue", sender: nil)
        case .authorizedWhenInUse:
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
