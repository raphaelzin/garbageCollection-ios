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
        navigationController.navigationBar.prefersLargeTitles = false
        return navigationController
    }()
    
    func start() {
        let viewModel = CalendarViewModel()
        let calendarController = CalendarController(viewModel: viewModel)
        calendarController.coordinatorDelegate = self
        
        navigationController.pushViewController(calendarController, animated: true)
    }
}

extension CalendarCoordinator: CalendarControllerCoordinatorDelegate {
    
    func didRequestNeighbourhoodSelection(from controller: CalendarController) {
        let viewModel = NeighbourhoodSelectionViewModel()
        let selectionController = NeighbourhoodSelectionController(viewModel: viewModel)
        selectionController.coordinatorDelegate = self
        selectionController.delegate = controller
        selectionController.hidesBottomBarWhenPushed = true
        
        navigationController.pushViewController(selectionController, animated: true)
    }
    
}

extension CalendarCoordinator: NeighbourhoodSelectionCoordenatorDelegate {
    
    func didRequestDismiss(from controller: NeighbourhoodSelectionController) {
        navigationController.popViewController(animated: true)
    }
    
}
