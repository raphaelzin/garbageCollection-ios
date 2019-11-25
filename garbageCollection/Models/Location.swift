//
//  Location.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-11-24.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import Foundation
import CoreLocation
import Parse

struct Location {
    
    let address: String
    let latitude: Double
    let longitude: Double
    
    var asGeoPoint: PFGeoPoint {
        .init(latitude: latitude, longitude: longitude)
    }
    
    var asCoreLocation: CLLocation {
        .init(latitude: latitude, longitude: longitude)
    }
    
}
