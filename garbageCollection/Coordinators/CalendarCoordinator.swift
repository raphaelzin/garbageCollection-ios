//
//  CalendarCoordinator.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-10-19.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import UIKit

class CalendarCoordinator: RootViewCoordinator {
    
    var childCoordinators: [Coordinator] = []
    var rootViewController: UIViewController {
        return self.navigationController
    }
    
    private lazy var navigationController: UINavigationController = {
        let navigationController = GCNavigationController()
        return navigationController
    }()
    
    func start() {
        let viewModel = CalendarViewModel()
        let calendarController = CalendarController(viewModel: viewModel)
        
        navigationController.pushViewController(calendarController, animated: true)
    }
}
