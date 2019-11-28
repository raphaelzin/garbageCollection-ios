//
//  LocationSelectionViewModel.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-11-26.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import Foundation
import RxSwift

protocol LocationSelectionViewModelType: class {
    func search(for address: String) -> Single<Location?>
}

class LocationSelectionViewModel: LocationSelectionViewModelType {
    
    private lazy var geocoderManager = GeocoderManager()
    
    func search(for address: String) -> Single<Location?> {
        geocoderManager.location(for: address)
    }
    
}
