//
//  AppDelegate.swift
//  HGRippleRadarView
//
//  Created by HamzaGhazouani on 01/27/2018.
//  Copyright (c) 2018 HamzaGhazouani. All rights reserved.
//

import UIKit
import TouchVisualizer

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions:
            [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Visualizer.start()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {

    }

    func applicationWillTerminate(_ application: UIApplication) {
    }

}
