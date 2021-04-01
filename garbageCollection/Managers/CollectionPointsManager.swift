//
//  CollectionPointsManager.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-11-05.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import Foundation
import Parse
import RxSwift

protocol CollectionPointsManagerProtocol: class {
    func fetchCollectionPoints() -> Single<[CollectionPoint]>
}

class CollectionPointsManager: CollectionPointsManagerProtocol {
    
    func fetchCollectionPoints() -> Single<[CollectionPoint]> {
        guard let query = CollectionPoint.query() else { return .error(GCError.Misc.invalidquery) }
        
        return query.rx.findObjects().map { (result) -> [CollectionPoint] in
            if let collectionSchedule = result as? [CollectionPoint] {
                return collectionSchedule
            } else {
                throw GCError.Server.invalidQueryResult
            }
        }.asSingle()
    }
    
}
