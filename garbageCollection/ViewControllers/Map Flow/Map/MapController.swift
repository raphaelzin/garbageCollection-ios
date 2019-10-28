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
    }
    
}
