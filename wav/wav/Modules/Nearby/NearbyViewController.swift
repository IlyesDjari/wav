//
//  NearbyViewController.swift
//  wav
//
//  Created by Ilyes Djari on 08/05/2023.
//

import UIKit
import MapKit

class NearbyViewController: UIViewController {

    // Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    // Properties
    internal let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getNearbyUser()
    }
    
    func getNearbyUser() {
        getNearbyUsers() { result in
            switch result {
            case .success(let usersData):
                for userData in usersData {
                    print(userData)
                }
            case .failure(let error):
                print("Error getting nearby users: \(error.localizedDescription)")
            }
        }
    }
}
