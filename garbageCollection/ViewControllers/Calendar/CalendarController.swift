//
//  CalendarController.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-10-19.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import UIKit

protocol CalendarControllerCoordinatorDelegate: class {
    
}

class CalendarController: GCViewModelController<CalendarViewModelType> {
    
    weak var coordinatorDelegate: CalendarControllerCoordinatorDelegate?
    
}
