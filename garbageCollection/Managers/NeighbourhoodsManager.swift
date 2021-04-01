//
//  NeighbourhoodsManager.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-10-23.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import Foundation
import Parse
import RxSwift

protocol NeighbourhoodsManagerProtocol: class {
    func fetchNeighbourhoods() -> Single<[Neighbourhood]>
}

class NeighbourhoodsManager: NeighbourhoodsManagerProtocol {
    
    func fetchNeighbourhoods() -> Single<[Neighbourhood]> {
        guard let query = Neighbourhood.query() else { return .error(GCError.Misc.invalidquery) }

        // Hardcoded Fortaleza-only neighbourhoods
        query.whereKey(Neighbourhood.Properties.cityId, equalTo: "1552")
        
        query.addAscendingOrder(Neighbourhood.Properties.name)
        
        return query
            .rx
            .findObjects()
            .map { ($0 as? [Neighbourhood]) ?? [] }
            .asSingle()
    }
    
}
