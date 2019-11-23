//
//  CollectionPointFilterViewModel.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-10-27.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import Foundation

protocol CollectionPointFilterViewModelType: class {
    var collectionPointTypes: [CollectionPoint.PointType] { get }
    var selectedCollectionPoints: [CollectionPoint.PointType] { get }
    
    func select(type: CollectionPoint.PointType)
    func unselect(type: CollectionPoint.PointType)
}

class CollectionPointFilterViewModel: CollectionPointFilterViewModelType {
    
    // MARK: Attributes
    
    let collectionPointTypes = CollectionPoint.PointType.allCases
    
    private(set) var selectedCollectionPoints = CollectionPoint.PointType.allCases
    
    // MARK: Lifecycle
    
    init(currentSelectedFilters: [CollectionPoint.PointType]) {
        selectedCollectionPoints = currentSelectedFilters
    }
    
}

extension CollectionPointFilterViewModel {
    
    func unselect(type: CollectionPoint.PointType) {
        guard let index = selectedCollectionPoints.firstIndex(of: type) else { return }
        selectedCollectionPoints.remove(at: index)
    }
    
    func select(type: CollectionPoint.PointType) {
        guard !selectedCollectionPoints.contains(type) else { return }
        selectedCollectionPoints.append(type)
    }
    
}
