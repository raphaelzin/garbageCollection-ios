//
//  MapCoordinator.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-10-19.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import UIKit

class MapCoordinator: RootViewCoordinator {
    
    var childCoordinators: [Coordinator] = []
    var rootViewController: UIViewController {
        return self.navigationController
    }
    
    private lazy var navigationController: UINavigationController = {
        let navigationController = GCNavigationController()
        return navigationController
    }()
    
    func start() {
        let viewModel = MapViewModel()
        let controller = MapController(viewModel: viewModel)
        controller.coordinatorDelegate = self
        navigationController.pushViewController(controller, animated: true)
    }
}

extension MapCoordinator: MapControllerCoordinatorDelegate {

    func didRequestFilterSelection(from controller: MapController) {
        let viewModel = CollectionPointFilterViewModel()
        let filtersController = CollectionPointFilterController(viewModel: viewModel)
        
        filtersController.coordinatorDelegate = self
        filtersController.filterDelegate = controller
        
        let navigationController = GCNavigationController(rootController: filtersController)
        controller.present(navigationController, animated: true)
    }
    
}

extension MapCoordinator: CollectionPointFilterCoordinatorDelegate {
    
    func didRequestDismiss(from controller: CollectionPointFilterController) {
        controller.dismiss(animated: true)
    }
    
}
