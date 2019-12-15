//
//  SettingsCoordinator.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-10-19.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import UIKit

class SettingsCoordinator: RootViewCoordinator {
    
    var childCoordinators: [Coordinator] = []
    var rootViewController: UIViewController {
        return self.navigationController
    }
    
    private lazy var navigationController: UINavigationController = {
        let navigationController = GCNavigationController()
        navigationController.navigationBar.prefersLargeTitles = true
        return navigationController
    }()
    
    func start() {
        let viewModel = SettingsViewModel()
        let controller = SettingsController(viewModel: viewModel)
        controller.coordinatorDelegate = self
        navigationController.pushViewController(controller, animated: true)
    }
}

extension SettingsCoordinator: SettingsControllerCoordinatorDelegate {
    
    func didRequestSourceCode(from controller: SettingsController) {
        let webController = WebController(linkType: .sourceCode)
        webController.coordinatorDelegate = self
        let navigator = GCNavigationController(rootController: webController)
        navigator.modalPresentationStyle = .fullScreen
        controller.present(navigator, animated: true)
    }
    
    func didRequestSuggestionForm(from controller: SettingsController) {
        let viewModel = FeedbackViewModel()
        let feedbackController = FeedbackController(viewModel: viewModel)
        feedbackController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(feedbackController, animated: true)
    }
    
    func didRequestNeighbourhoodSelection(from controller: SettingsController) {
        let viewModel = NeighbourhoodSelectionViewModel()
        let selectionController = NeighbourhoodSelectionController(viewModel: viewModel)
        selectionController.coordinatorDelegate = self
        selectionController.delegate = controller
        selectionController.hidesBottomBarWhenPushed = true
        
        navigationController.pushViewController(selectionController, animated: true)
    }
    
}

extension SettingsCoordinator: NeighbourhoodSelectionCoordenatorDelegate {
    
    func didRequestDismiss(from controller: NeighbourhoodSelectionController) {
        navigationController.popViewController(animated: true)
    }
    
}

extension SettingsCoordinator: WebControllerCoordinatorDelegate {
    
    func didRequestDismiss(controller: WebController) {
        controller.dismiss(animated: true)
    }
    
}
