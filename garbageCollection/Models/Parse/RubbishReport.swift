//
//  RubbishReport.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-10-20.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import Foundation
import Parse

class RubbishReport: PFObject, PFSubclassing {
    
    @NSManaged var location: PFGeoPoint?
    @NSManaged var address: String?
    @NSManaged var comment: String?
    @NSManaged var zipcode: String?
    @NSManaged var isValid: Bool
    @NSManaged var reporter: Installation?
    @NSManaged var picture: PFFileObject?
    @NSManaged var seenTimestamp: Date?
    
    static func parseClassName() -> String { return "RubbishReport" }
    
}

// MARK: Properties

extension RubbishReport {
    
    struct Properties {
        static let location = "location"
        static let address = "address"
        static let comment = "comment"
        static let isValid = "isValid"
        static let reporter = "reporter"
        static let picture = "picture"
        static let seenTimestamp = "seenTimestamp"
    }
    
}
