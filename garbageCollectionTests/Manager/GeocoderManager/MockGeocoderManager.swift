//
//  MockGeocoderManager.swift
//  garbageCollectionTests
//
//  Created by Raphael Souza on 2020-04-26.
//  Copyright © 2020 Raphael Inc. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift

@testable import garbageCollection

class MockGeocoderManager: GeocoderManagerType {
    
    private let stdLocation = Location(address: "My Address",
                                       zipcode: "ZIPCODE",
                                       location: CLLocation())
    
    func location(for address: String) -> Single<Location?> {
        if address.isEmpty {
            return .just(nil)
        } else {
            return .just(stdLocation)
        }
    }
    
    func location(for latitude: Double, and longitude: Double) -> Single<Location?> {
        if latitude == 0 && longitude == 0 {
            return .just(nil)
        } else {
            return .just(stdLocation)
        }
    }
    
}
