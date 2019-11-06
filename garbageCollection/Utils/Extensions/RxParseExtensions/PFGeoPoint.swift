//
//  PFGeoPoint.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-11-05.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import Parse
import MapKit

extension PFGeoPoint {
    
    var CLCoordinates: CLLocationCoordinate2D {
        .init(latitude: latitude, longitude: longitude)
    }
    
}
