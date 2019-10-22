//
//  ParseSetup.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-10-20.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import Parse

class ParseSetup {
    
    /** Create connection from Parse */
    class func initialize() {
        ParseSetup.registerSubclasses()
        ParseSetup.setupConnection()
    }
    
    class func setupConnection() {
        let configuration = ParseClientConfiguration {
            $0.applicationId = Environment.getValue(forKey: .parseAppId)
            $0.server = Environment.getValue(forKey: .parseServerURL)
            $0.isLocalDatastoreEnabled = true
        }
        
        Parse.enableLocalDatastore()
        Parse.initialize(with: configuration)

        Installation.current()?.badge = 0
        Installation.current()?.saveInBackground()
    }
    
    class func registerSubclasses() {
        Installation.registerSubclass()
        City.registerSubclass()
        Neighbourhood.registerSubclass()
    }
    
}
