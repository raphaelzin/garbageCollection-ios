//
//  GCNavigationController.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-10-19.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import UIKit

class GCNavigationController: UINavigationController {
    convenience init(rootController: UIViewController? = nil) {
        self.init(navigationBarClass: GCNavigationBar.self, toolbarClass: nil)
        
        if let rootViewController = rootController {
            viewControllers = [rootViewController]
        }
        navigationBar.isTranslucent = false
        navigationBar.shadowImage = UIImage()
    }
}
