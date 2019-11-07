//
//  AppCoordinator.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-10-19.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import UIKit

class AppCoordinator: RootViewCoordinator {
    
    // MARK: - Properties
    var childCoordinators: [Coordinator] = []
    private(set) var rootViewController: UIViewController = SplashController() {
        didSet {
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.window.rootViewController = self.rootViewController
            })
        }
    }
    
    /// Window to manage
    let window: UIWindow
    
    // MARK: - Init
    
    public init(window: UIWindow) {
        self.window = window
        window.backgroundColor = .systemBackground
        self.window.rootViewController = self.rootViewController
        self.window.makeKeyAndVisible()
    }
    
    private func setCurrentCoordinator(_ coordinator: RootViewCoordinator) {
        rootViewController = coordinator.rootViewController
    }
    
    // MARK: - Functions
    
    /// Starts the coordinator
    public func start() {
        _ = try? Installation.current()?.neighbourhood?.fetch()
        setupTabBar()
    }
}

// MARK: Private methods

private extension AppCoordinator {
    
    func setupTabBar() {
        let calendarCoordinator = CalendarCoordinator()
        let settingsCoordinator = SettingsCoordinator()
        let mapCoordinator = MapCoordinator()
        
        let coordinators: [RootViewCoordinator] = [calendarCoordinator, mapCoordinator, settingsCoordinator]
        self.childCoordinators = coordinators
        
        coordinators.forEach { $0.start() }
        
        let tabBar = UITabBarController()
        tabBar.setViewControllers(coordinators.map { $0.rootViewController }, animated: true)
        
        rootViewController = tabBar
    }
    
}
