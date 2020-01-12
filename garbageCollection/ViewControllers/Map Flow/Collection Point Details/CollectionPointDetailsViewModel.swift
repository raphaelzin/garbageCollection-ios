//
//  CollectionPointDetailsViewModel.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2020-01-12.
//  Copyright © 2020 Raphael Inc. All rights reserved.
//

protocol CollectionPointDetailsViewModelType: class {
    var collectionPoint: CollectionPoint { get }
}

import Foundation

class CollectionPointDetailsViewModel: CollectionPointDetailsViewModelType {
    
    let collectionPoint: CollectionPoint
    
    init(collectionPoint: CollectionPoint) {
        self.collectionPoint = collectionPoint
    }
    
}
