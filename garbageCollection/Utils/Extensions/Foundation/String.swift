//
//  String.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-10-20.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import Foundation

extension String {
    
    var isValidTime: Bool {
        let pattern = "^([01]?[0-9]|2[0-3]):[0-5][0-9]$"
        return matches(pattern)
    }
    
    private func matches(_ pattern: String) -> Bool {
        self.range(of: pattern, options: .regularExpression) != nil
    }
    
}
