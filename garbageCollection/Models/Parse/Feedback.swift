//
//  Feedback.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-10-20.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import Foundation
import Parse

class Feedback: PFObject, PFSubclassing {
    
    @NSManaged var author: Installation?
    @NSManaged var comment: String?
    @NSManaged var name: String?
    @NSManaged var email: String?
    
    static func parseClassName() -> String { return "Feedback" }
    
}

// MARK: Properties

extension Feedback {
    
    struct Properties {
        static let author = "author"
        static let comment = "comment"
        static let name = "name"
        static let email = "email"
    }
    
}
