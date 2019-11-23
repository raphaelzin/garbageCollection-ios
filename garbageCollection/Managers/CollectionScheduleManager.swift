//
//  CollectionPointsManager.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-10-21.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import Foundation
import Parse
import RxSwift

class CollectionScheduleManager {
    
    func collectionSchedule(for neighbourhood: Neighbourhood) -> Single<CollectionSchedule> {
        guard let query = CollectionSchedule.query() else { return .error(GCError.Misc.invalidquery) }
        query.whereKey(CollectionSchedule.Properties.neighbourhood, equalTo: neighbourhood)
        
        return query.rx.getFirstObject().map { (object) -> CollectionSchedule in
            if let collectionSchedule = object as? CollectionSchedule {
                return collectionSchedule
            } else {
                throw GCError.Server.invalidQueryResult
            }
        }.asSingle()
    }
    
}
