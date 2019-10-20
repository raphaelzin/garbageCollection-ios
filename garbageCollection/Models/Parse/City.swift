//
//  City.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-10-20.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import Foundation
import Parse

class City: PFObject, PFSubclassing {
    
    @NSManaged var name: String?
    @NSManaged var identifier: String?
    
    static func parseClassName() -> String { return "City" }
    
}

// MARK: Properties

extension City {
    
    struct Properties {
        static let name = "name"
        static let identifier = "identifier"
    }
    
}
