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

class CollectionPointsManager {
    
    func collectionSchedule(for neighbourhood: Neighbourhood) -> Single<CollectionSchedule> {
        return .never()
    }
    
}
