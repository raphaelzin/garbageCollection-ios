//
//  InstallationManager.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-12-21.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import Foundation

class InstallationManager {
    
    func registerForNotifications(with token: String) {
        guard let installation = Installation.current() else { return }
        installation.deviceToken = token
        installation.saveInBackground()
    }
    
}
