//
//  MapController.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-10-19.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import UIKit
import MapKit

protocol MapControllerCoordinatorDelegate: class {
    
}

class MapController: GCViewModelController<MapViewModelType> {
    
    weak var coordinatorDelegate: MapControllerCoordinatorDelegate?
    
    // Subviews
    
    private lazy var mapView: MKMapView = {
        let map = MKMapView()
        return map
    }()
    
    private lazy var filterButton: GCExpandableButton = {
        let btn = GCExpandableButton()
        btn.contentTextColor = .brownGrey
        return btn
    }()
    
    private lazy var reportButton: GCExpandableButton = {
        let btn = GCExpandableButton()
        btn.contentTextColor = .white
        btn.buttonBackgroundColor = .orangeyRed
        btn.contentBackgroundColor = .orangeyRed
        
        let image = UIImage(systemName: "exclamationmark.triangle")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        btn.buttonIcon = image
        
        return btn
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        reportButton.setState(.expanded, afterInterval: 1)
        reportButton.setState(.collapsed, afterInterval: 3)
    }
    
    override init(viewModel: MapViewModelType) {
        super.init(viewModel: viewModel)
        
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: Private Layout methods

private extension MapController {
    
    func configureView() {
        navigationItem.title = "Pontos de coleta"
        
        if #available(iOS 13.0, *) {
            tabBarItem = UITabBarItem(title: "Mapa", image: UIImage(systemName: "map"), tag: 0)
        }
    }
    
    func configureLayout() {
        view.addSubview(mapView)
        mapView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        view.addSubview(filterButton)
        filterButton.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(24)
            make.trailing.equalTo(view).offset(-16)
            make.width.greaterThanOrEqualTo(36)
            make.height.equalTo(36)
        }
        
        view.addSubview(reportButton)
        reportButton.snp.makeConstraints { (make) in
            make.top.equalTo(filterButton.snp.bottom).offset(12)
            make.trailing.equalTo(view).offset(-16)
            make.width.greaterThanOrEqualTo(36)
            make.height.equalTo(36)
        }
    }
    
}
