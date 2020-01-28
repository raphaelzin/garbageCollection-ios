//
//  Analytics.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2020-01-21.
//  Copyright © 2020 Raphael Inc. All rights reserved.
//

import Foundation
import Firebase

enum TrackedEvent: String {
    case neighbourhoodSelection
    case collectionPointDetails
    
}
//Analytics.logEvent(TrackedEvent.neighbourhoodSelection.raw, parameters: ["selected": neighbourhood.name ?? ""])
extension Analytics {
    
    static func logTrackedEvent(_ event: TrackedEvent, parameters: [String: String]?) {
        logEvent(event.rawValue, parameters: parameters)
    }
    
}
