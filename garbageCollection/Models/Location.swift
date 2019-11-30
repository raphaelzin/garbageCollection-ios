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
    let zipcode: String
    let latitude: Double
    let longitude: Double
    
    init(address: String, zipcode: String, location: CLLocation) {
        self.address = address
        self.zipcode = zipcode
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
    }
    
    init(address: String, zipcode: String, latitude: Double, longitude: Double) {
        self.address = address
        self.zipcode = zipcode
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
