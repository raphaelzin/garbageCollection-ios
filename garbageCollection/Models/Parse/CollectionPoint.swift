//
//  CollectionPoint.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-10-20.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import Foundation
import Parse

class CollectionPoint: PFObject, PFSubclassing {
    
    @NSManaged var bairro: String?
    @NSManaged var identifier: String?
    @NSManaged var name: String?
    @NSManaged var address: String?
    @NSManaged var yearRef: String?
    @NSManaged var source: String?
    @NSManaged var regional: String?
    @NSManaged var location: PFGeoPoint?
    
    @NSManaged private var type: String?
    
    static func parseClassName() -> String { return "CollectionPoint" }
    
}

// MARK: Properties

extension CollectionPoint {
    
    struct Properties {
        static let bairro = "bairro"
        static let identifier = "identifier"
        static let name = "name"
        static let address = "address"
        static let yearRef = "yearRef"
        static let source = "source"
        static let regional = "regional"
        static let location = "location"
    }
    
}
