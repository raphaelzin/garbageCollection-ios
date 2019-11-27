//
//  LocationSelectionController.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-11-26.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MapKit

protocol LocationSelectionControllerCoordinatorDelegate: class {
    func didRequestDismiss(from controller: UIViewController)
}

class LocationSelectionController: GCViewModelController<LocationSelectionViewModelType> {
    
    // MARK: Attributes
    
    weak var coordinatorDelegate: LocationSelectionControllerCoordinatorDelegate?
    
    // MARK: Subviews
    
    private lazy var mapView: MKMapView = {
        let mv = MKMapView()
        return mv
    }()
    
    private lazy var addressTextField: UITextField = {
        let tf = UITextField()
        tf.layer.cornerRadius = 22
        tf.leftViewMode = .always
        tf.backgroundColor = .systemBackground
        let imv = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        imv.contentMode = .center
        imv.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 44, height: 44))
        }
        tf.leftView = imv
        return tf
    }()
    
    // MARK: LifeCycle
    
    override init(viewModel: LocationSelectionViewModelType) {
        super.init(viewModel: viewModel)
        
        configureLayout()
        configureNavBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: Private layout methods

private extension LocationSelectionController {
    
    func configureLayout() {
        view.addSubview(mapView)
        mapView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        view.addSubview(addressTextField)
        addressTextField.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            make.leading.top.trailing.equalTo(view).inset(16)
        }
    }
    
    func configureNavBar() {
        navigationItem.title = "Selecionar localização"
    }
}

// MARK: Private selectors

private extension LocationSelectionController {
    
    @objc func onSaveTap() {
        coordinatorDelegate?.didRequestDismiss(from: self)
    }
    
}
