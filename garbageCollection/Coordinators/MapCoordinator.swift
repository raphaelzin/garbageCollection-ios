//
//  MapCoordinator.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-10-19.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import UIKit
import Photos
import AVKit

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
    
    func didRequestMoreInfo(from controller: MapController) {
        let moreInfoController = MoreInfoController()
        moreInfoController.coordinatorDelegate = self
        moreInfoController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(moreInfoController, animated: true)
    }
    
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

extension MapCoordinator: MoreInfoControllerCoordinatorDelegate {
    
    func didRequestDetails(for type: CollectionPoint.PointType) {
        let detailsController = CollectionPointInfoController(type: type)
        navigationController.pushViewController(detailsController, animated: true)
    }
    
}

extension MapCoordinator: CollectionPointFilterCoordinatorDelegate {
    
    func didRequestDismiss(from controller: CollectionPointFilterController) {
        controller.dismiss(animated: true)
    }
    
}

extension MapCoordinator: RubbishReportControllerDelegate {
    
    func didRequestDateSelection(from controller: RubbishReportController, callback: @escaping (Date) -> Void) {
        let alert = UIAlertController(style: .actionSheet, title: "Selecione uma data")
        alert.addDatePicker(mode: .dateAndTime, date: Date(), minimumDate: nil, maximumDate: nil) { date in
            callback(date)
        }
        alert.addAction(title: "Fechar", style: .cancel)
        controller.present(alert, animated: true)
    }
    
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

    func didRequestImagePick(from controller: RubbishReportController) {
        PHPhotoLibrary.requestAuthorization { auth in
            if auth == .authorized {
                
            }
        }
    }
    
    func didRequestLocation(from controller: UIViewController) {
        let viewModel = LocationSelectionViewModel()
        let locationSelectionController = LocationSelectionController(viewModel: viewModel)
        locationSelectionController.coordinatorDelegate = self
        locationSelectionController.delegate = controller as? LocationSelectionDelegate
        controller.navigationController?.pushViewController(locationSelectionController, animated: true)
    }
    
}

extension MapCoordinator: LocationSelectionControllerCoordinatorDelegate {
    
    func didRequestDismiss(from controller: UIViewController) {
        controller.navigationController?.popViewController(animated: true)
    }
    
}

extension MapCoordinator: TextInputControllerCoordinatorDelegate {
    
    func didRequestDismiss(from controller: TextInputController) {
        controller.navigationController?.popViewController(animated: true)
    }
    
}

// MARK: Photo access

extension MapCoordinator {
    
    func didRequestPhoto(from controller: UIViewController, withSource source: UIImagePickerController.SourceType) {
        if source == .camera {
            didRequestCamera(from: controller)
        } else if source == .photoLibrary {
            didRequestPhotoLibrary(from: controller)
        }
    }
    
    private func didRequestCamera(from controller: UIViewController) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
        
        AVCaptureDevice.requestAccess(for: .video) { success in
            DispatchQueue.main.async {
                guard success else {
                    return
                }
                
                let picker = UIImagePickerController()
                picker.sourceType = .camera
                picker.delegate = controller as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
                controller.present(picker, animated: true, completion: nil)
            }
        }
    }
    
    private func didRequestPhotoLibrary(from controller: UIViewController) {
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                guard status == .authorized else {
                    return
                }
                
                let picker = UIImagePickerController()
                picker.sourceType = .photoLibrary
                picker.delegate = controller as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
                picker.mediaTypes = ["public.image"]
                controller.present(picker, animated: true, completion: nil)
            }
        }
    }
    
}
