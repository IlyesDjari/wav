//
//  NearbyViewController.swift
//  wav
//
//  Created by Ilyes Djari on 08/05/2023.
//

import UIKit
import HGRippleRadarView
import CoreLocation

class NearbyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {

    // Outlets
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }

    @IBOutlet weak var radarView: RadarView! {
        didSet {
            radarView.delegate = self
            radarView.dataSource = self
        }
    }

    // Properties
    internal var usersData: [NearbyUser] = []
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    private let loadingIndicator = LoadingIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor(named: "Purple")
        UITableViewCell.appearance().selectedBackgroundView = selectedView
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        loadingIndicator.show(on: self.view)
        Task {
            updateLocation()
            getNearbyUser()
            setRadar()
            DispatchQueue.main.async {
                self.loadingIndicator.hide()
            }
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        for user in usersData {
            let item = Item(uniqueKey: user.id, value: user)
            radarView.remove(item: item)
        }
    }

    private func updateLocation() {
        guard let location = locationManager.location else {
            print("Unable to fetch location.")
            return
        }
        currentLocation = location
        // Call function to update location in the database
        updateLocationDB(location: currentLocation) { result in
            switch result {
            case .success:
                print("Location updated successfully in the database.")
            case .failure(let error):
                print("Failed to update location: \(error.localizedDescription)")
            }
        }
    }

    private func getNearbyUser() {
        getNearbyUsers() { [weak self] result in
            switch result {
            case .success(let usersData):
                DispatchQueue.main.async {
                    self?.usersData = usersData
                    self?.tableView.reloadData()
                    for user in usersData {
                        let item = Item(uniqueKey: user.id, value: user)
                        self?.radarView.add(item: item)
                    }
                }
            case .failure(let error):
                print("Error getting nearby users: \(error.localizedDescription)")
            }
        }
    }
}
