//
//  GeocoderManager.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-11-27.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import Foundation
import RxSwift
import CoreLocation

class GeocoderManager {
    
    let geocoder = CLGeocoder()
    
    func location(for latitude: Double, and longitude: Double) -> Single<Location?> {
        Single.create { single -> Disposable in
            self.geocoder.reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) {
                self.handleGeocodeResult(single: single, places: $0, error: $1)
            }
            return Disposables.create()
        }
        
    }
    
    func location(for address: String) -> Single<Location?> {
        Single.create { (single) -> Disposable in
            self.geocoder.geocodeAddressString(address) {
                self.handleGeocodeResult(single: single, places: $0, error: $1)
            }
            return Disposables.create()
        }
    }
    
    func handleGeocodeResult(single: ((SingleEvent<Location?>) -> Void), places: [CLPlacemark]?, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            // Filter geocode obliviousness error
            if (error as NSError).code == 8 {
                single(.success(nil))
            } else {
                single(.error(error))
            }
            return
        }
        
        guard let places = places, !places.isEmpty else {
            single(.error(GCError.Geocoder.invalidGeocoderResponse))
            return
        }
        
        let place = places.filter { singlePlace in singlePlace.locality == "Fortaleza" }.first
        
        guard let fortalezaPlace = place else {
            single(.success(nil))
            return
        }
        let name = [fortalezaPlace.name, fortalezaPlace.postalCode].compactMap { $0 }.joined(separator: " - ")
        single(.success(Location(address: name, location: fortalezaPlace.location!)))
    }
    
}
