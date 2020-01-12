//
//  Environment.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-10-19.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import Foundation

struct Environment {
    
    static func getValue(forKey key: Key) -> String {
        return infoForKey(key.rawValue)
    }
    
    private static func infoForKey(_ key: String) -> String {
        guard let value = (Bundle.main.infoDictionary?[key] as? String) else {
            fatalError("Could not get value for key: \(key)")
        }
        return value.replacingOccurrences(of: "\\", with: "")
    }
    
}

extension Environment {
    
    enum Key: String {
        case bundleId
        case parseAppId = "PARSE_APP_ID"
        case parseServerURL = "PARSE_SERVER_URL"
        case serverBaseURL = "SERVER_BASE_URL"
    }
    
}
