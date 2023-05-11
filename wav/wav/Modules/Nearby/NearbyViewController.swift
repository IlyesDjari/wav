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
}
