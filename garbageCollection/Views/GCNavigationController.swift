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
        self.init()
        
        if let rootViewController = rootController {
            viewControllers = [rootViewController]
        }
    }
    
    init() {
        super.init(navigationBarClass: GCNavigationBar.self, toolbarClass: nil)
        
        navigationBar.isTranslucent = false
        navigationBar.shadowImage = UIImage()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
