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
        getNearbyUser()
    }
    
    func getNearbyUser() {
        getNearbyUsers() { [weak self] result in
            switch result {
            case .success(let usersData):
                DispatchQueue.main.async {
                    self?.addPointsOnMap(usersData)
                }
            case .failure(let error):
                print("Error getting nearby users: \(error.localizedDescription)")
            }
        }
    }
    
    func addPointsOnMap(_ usersData: [NearbyUser]) {
        for userData in usersData {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: userData.latitude, longitude: userData.longitude)
            annotation.title = userData.username
            mapView.addAnnotation(annotation)
        }
    }
}
