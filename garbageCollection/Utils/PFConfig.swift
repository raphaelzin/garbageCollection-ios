//
//  PFConfig.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2020-02-24.
//  Copyright © 2020 Raphael Inc. All rights reserved.
//

import Foundation
import Parse

extension PFConfig {
    
    enum ConfigField: String {
        case shareAppMessage, shareURL
    }
    
    func getConfigValue<T>(with param: ConfigField) -> T? {
        object(forKey: param.rawValue) as? T
    }
    
    func getConfigValue<T>(with param: String) -> T? {
        object(forKey: param) as? T
    }
    
}
