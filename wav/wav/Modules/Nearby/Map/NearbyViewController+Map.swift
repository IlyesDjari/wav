//
//  NearbyViewController+Map.swift
//  wav
//
//  Created by Ilyes Djari on 11/05/2023.
//

import Foundation
import MapKit
import CoreLocation

extension NearbyViewController {
    
   internal func setupMapView() {
            // Set initial map region to the user's location
            if let userLocation = locationManager.location?.coordinate {
                let regionRadius: CLLocationDistance = 1000
                let coordinateRegion = MKCoordinateRegion(center: userLocation,
                                                          latitudinalMeters: regionRadius,
                                                          longitudinalMeters: regionRadius)
                mapView.setRegion(coordinateRegion, animated: true)
            }
            // Customize map appearance
            mapView.mapType = .standard
            mapView.showsUserLocation = true
    }
}
