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
    var selectedFilters: [CollectionPoint.PointType] { get }
    var highlightedCollectionPoint: Observable<CollectionPoint?> { get }
    
    func indexPath(of collectionPoint: CollectionPoint) -> IndexPath?
    func highlight(_ collectionPoint: CollectionPoint?)
    func updateSelected(filters: [CollectionPoint.PointType])
}

class MapViewModel: MapViewModelType {
    
    // MARK: Private attributes
    
    private let collectionPointsManager = CollectionPointsManager()
    
    private let highlighedCollectionPointRelay = BehaviorRelay<CollectionPoint?>(value: nil)
    
    private let collectionPointsRelay = BehaviorRelay<[CollectionPoint]>(value: [])
    
    private let selectedFiltersRelay = BehaviorRelay<[CollectionPoint.PointType]>(value: CollectionPoint.PointType.allCases)
    
    private let disposeBag = DisposeBag()
    
    // MARK: Public attributes
    
    var highlightedCollectionPoint: Observable<CollectionPoint?> {
        highlighedCollectionPointRelay.asObservable()
    }
    
    var collectionPoints: Observable<[CollectionPoint]> {
        Observable
            .combineLatest(collectionPointsRelay.asObservable(), selectedFiltersRelay.asObservable())
            .map { (collectionPoints, filters) -> [CollectionPoint] in
                guard !filters.isEmpty else { return collectionPoints }
                return collectionPoints.filter { $0.safeType != nil && filters.contains($0.safeType!) }
            }
    }
    
    var selectedFilters: [CollectionPoint.PointType] {
        return selectedFiltersRelay.value
    }
    
    // MARK: Lifecycle
    
    init() {
        fetchCollectionPoints()
    }
    
}

// MARK: Public methods

extension MapViewModel {
    
    func updateSelected(filters: [CollectionPoint.PointType]) {
        highlighedCollectionPointRelay.accept(nil)
        selectedFiltersRelay.accept(filters)
        
    }
    
    func highlight(_ collectionPoint: CollectionPoint?) {
        guard collectionPoint != highlighedCollectionPointRelay.value else { return }
        highlighedCollectionPointRelay.accept(collectionPoint)
    }
    
    func indexPath(of collectionPoint: CollectionPoint) -> IndexPath? {
        guard let row = collectionPointsRelay.value.firstIndex(of: collectionPoint) else { return nil }
        return IndexPath(row: row, section: 0)
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
