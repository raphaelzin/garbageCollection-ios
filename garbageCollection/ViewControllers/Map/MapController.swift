//
//  MapController.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-10-19.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import UIKit

protocol MapControllerCoordinatorDelegate: class {
    
}

class MapController: GCViewModelController<MapViewModelType> {
    
    weak var coordinatorDelegate: MapControllerCoordinatorDelegate?
    
}
