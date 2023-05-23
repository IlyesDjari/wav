//
//  TabBarViewController.swift
//  wav
//
//  Created by Ilyes Djari on 23/05/2023.
//

import UIKit

class TabBarViewController: UITabBarController {
    static let shared = TabBarViewController()

    var liveSessionPlayerViewController: LiveSessionPlayerViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let navigationController = selectedViewController as? UINavigationController,
           let liveSessionPlayerVC = navigationController.viewControllers.first as? LiveSessionPlayerViewController {
            liveSessionPlayerViewController = liveSessionPlayerVC
        }
    }
}
