//
//  LiveSessionPlayerViewController.swift
//  wav
//
//  Created by Ilyes Djari on 17/05/2023.
//

import UIKit

class LiveSessionPlayerViewController: UIViewController {
    
    internal var usersData: NearbyUser? = nil


    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAllData()
    }
    
    private func fetchAllData() {
        getSongInfo(songID: usersData?.songID ?? "")
    }
}
