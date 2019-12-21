//
//  AppDelegate.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-10-17.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        ParseSetup.initialize()
        setupGlobalAppearances()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        appCoordinator = AppCoordinator(window: window!)
        appCoordinator.start()
        return true
    }
    
    private func setupGlobalAppearances() {
        UISwitch.appearance().onTintColor = .defaultBlue
    }

}
