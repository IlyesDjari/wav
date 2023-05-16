//
//  NearbyViewController.swift
//  wav
//
//  Created by Ilyes Djari on 08/05/2023.
//

import UIKit
import HGRippleRadarView

class NearbyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

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
    override func viewDidLoad() {
        super.viewDidLoad()
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor(named: "Purple")
        UITableViewCell.appearance().selectedBackgroundView = selectedView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        getNearbyUser()
        setRadar()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        for user in usersData {
            let item = Item(uniqueKey: user.id, value: user)
            radarView.remove(item: item)
        }
    }
    
    func getNearbyUser() {
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
