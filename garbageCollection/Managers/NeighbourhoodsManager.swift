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

class NeighbourhoodsManager {
    
    func fetchNeighbourhoods(with term: String = "") -> Single<[Neighbourhood]> {
        guard let query = Neighbourhood.query() else { return .error(GCError.Misc.invalidquery) }

        // Hardcoded Fortaleza-only neighbourhoods
        query.whereKey(Neighbourhood.Properties.cityId, equalTo: "1552")
        
        if !term.isEmpty {
            query.whereKey(Neighbourhood.Properties.name, matchesRegex: term, modifiers: "i")
        }
        
        query.addAscendingOrder(Neighbourhood.Properties.name)
        
        return query
            .rx
            .findObjects()
            .map { ($0 as? [Neighbourhood]) ?? [] }
            .asSingle()
    }
    
}
