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
    
    init(address: String, location: CLLocation) {
        self.address = address
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
    }
    
    init(address: String, latitude: Double, longitude: Double) {
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
    }
    
    var asGeoPoint: PFGeoPoint {
        .init(latitude: latitude, longitude: longitude)
    }
    
    var asCoreLocation: CLLocation {
        .init(latitude: latitude, longitude: longitude)
    }
    
}
