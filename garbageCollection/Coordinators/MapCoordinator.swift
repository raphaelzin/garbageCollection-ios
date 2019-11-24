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

    func didRequestFilterSelection(from controller: MapController, with currentSelection: [CollectionPoint.PointType]) {
        let viewModel = CollectionPointFilterViewModel(currentSelectedFilters: currentSelection)
        let filtersController = CollectionPointFilterController(viewModel: viewModel)
        
        filtersController.coordinatorDelegate = self
        filtersController.filterDelegate = controller
        
        let navigationController = GCNavigationController(rootController: filtersController)
        controller.present(navigationController, animated: true)
    }
    
    func didRequestRubbishReport(from controller: MapController) {
        let viewModel = RubbishReportViewModel()
        let rubbishReportController = RubbishReportController(viewModel: viewModel)
        rubbishReportController.coordinatorDelegate = self
        
        let navigator = GCNavigationController(rootController: rubbishReportController)
        navigator.modalPresentationStyle = .fullScreen
        
        controller.present(navigator, animated: true)
    }
    
}

extension MapCoordinator: CollectionPointFilterCoordinatorDelegate {
    
    func didRequestDismiss(from controller: CollectionPointFilterController) {
        controller.dismiss(animated: true)
    }
    
}

extension MapCoordinator: RubbishReportControllerDelegate {
    
    func didRequestDismiss(from controller: RubbishReportController) {
        controller.dismiss(animated: true)
    }
    
    func didRequestDetailsInput(from controller: RubbishReportController) {
        let textInputController = TextInputController(configurator: .init(title: "Detalhes",
                                                                          placeholder: "Detalhes sobre o descarte impróprio.",
                                                                          actionButtonTitle: "Salvar"))
        textInputController.delegate = controller
        textInputController.coordinatorDelegate = self
        
        controller.navigationController?.pushViewController(textInputController, animated: true)
    }

}

extension MapCoordinator: TextInputControllerCoordinatorDelegate {
    
    func didRequestDismiss(from controller: TextInputController) {
        controller.dismiss(animated: true)
    }
    
}
