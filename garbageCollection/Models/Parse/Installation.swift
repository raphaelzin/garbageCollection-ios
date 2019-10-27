//
//  Installation.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-10-20.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import Foundation
import Parse

class Installation: PFInstallation {
    
    // Parse attributes
    @NSManaged private var minutesInAdvance: NSNumber?
    
    @NSManaged var neighbourhood: Neighbourhood?
    @NSManaged var hintsEnabled: Bool
    @NSManaged var notificationsEnabled: Bool
    
    // helper getters
    
    var minutesBeforeCollectionNotification: Int {
        return minutesInAdvance?.intValue ?? 0
    }
    
}
