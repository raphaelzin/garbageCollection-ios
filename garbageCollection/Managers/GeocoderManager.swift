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
            self.geocoder.reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { (places: [CLPlacemark]?, error: Error?) in
                if let error = error {
                    single(.error(error))
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
                
                single(.success(Location(address: fortalezaPlace.name ?? "", latitude: latitude, longitude: longitude)))
            }
            return Disposables.create()
        }
        
    }
    
    func location(for address: String) -> Single<Location?> {
        Single.create { (single) -> Disposable in
            self.geocoder.geocodeAddressString(address) { places, error in
                if let error = error {
                    single(.error(error))
                }
                
                guard let places = places, !places.isEmpty else {
                    single(.error(GCError.Geocoder.invalidGeocoderResponse))
                    return
                }
                
                print(places)
                let place = places.filter { singlePlace in singlePlace.locality == "Fortaleza" }.first
                
                guard let fortalezaPlace = place else {
                    single(.success(nil))
                    return
                }

                single(.success(Location(address: address, location: fortalezaPlace.location!)))
            }
            return Disposables.create()
            
        }
    }
    
}
