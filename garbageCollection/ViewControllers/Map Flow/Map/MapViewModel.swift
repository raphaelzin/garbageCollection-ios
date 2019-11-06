//
//  MapViewModel.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-10-19.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol MapViewModelType: class {
    var collectionPoints: Observable<[CollectionPoint]> { get }
    
    func updateSelected(filters: [CollectionPoint.PointType])
}

class MapViewModel: MapViewModelType {
    
    // MARK: Private attributes
    
    private let collectionPointsManager = CollectionPointsManager()
    
    private let collectionPointsRelay = BehaviorRelay<[CollectionPoint]>(value: [])
    
    private let selectedFiltersRelay = BehaviorRelay<[CollectionPoint.PointType]>(value: [])
    
    private let disposeBag = DisposeBag()
    
    // MARK: Public attributes
    
    var collectionPoints: Observable<[CollectionPoint]> {
        Observable
            .combineLatest(collectionPointsRelay.asObservable(), selectedFiltersRelay.asObservable())
            .map { (collectionPoints, filters) -> [CollectionPoint] in
                guard !filters.isEmpty else { return collectionPoints }
                return collectionPoints.filter { $0.safeType != nil && filters.contains($0.safeType!)
            }
        }
    }
    
    // MARK: Lifecycle
    
    init() {
        fetchCollectionPoints()
    }
    
}

// MARK: Public methods

extension MapViewModel {
    
    func updateSelected(filters: [CollectionPoint.PointType]) {
        selectedFiltersRelay.accept(filters)
    }
    
}

// MARK: Private methods

private extension MapViewModel {
    
    func fetchCollectionPoints() {
        collectionPointsManager
            .collectionPoints()
            .asDriver(onErrorJustReturn: [])
            .drive(collectionPointsRelay)
            .disposed(by: disposeBag)
    }
    
}
