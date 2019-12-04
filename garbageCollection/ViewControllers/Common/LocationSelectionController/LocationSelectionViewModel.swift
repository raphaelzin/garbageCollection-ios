//
//  LocationSelectionViewModel.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-11-26.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol LocationSelectionViewModelType: class {
    func search(for address: String) -> Single<Location?>
    func search(with latitude: Double, and longitude: Double) -> Single<Location?>
    
    var selectedLocation: BehaviorRelay<Location?> { get }
}

class LocationSelectionViewModel: LocationSelectionViewModelType {
    
    private let disposeBag = DisposeBag()
    
    private lazy var geocoderManager = GeocoderManager()
    
    lazy var selectedLocation: BehaviorRelay<Location?> = .init(value: nil)
        
    func search(for address: String) -> Single<Location?> {
        geocoderManager
            .location(for: address)
            .do(onSuccess: { (location) in
                self.selectedLocation.accept(location)
            })
    }
    
    func search(with latitude: Double, and longitude: Double) -> Single<Location?> {
        geocoderManager
            .location(for: latitude, and: longitude)
            .do(onSuccess: { (location) in
                self.selectedLocation.accept(location)
            })
    }
    
}
