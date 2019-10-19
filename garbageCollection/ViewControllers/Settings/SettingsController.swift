//
//  SettingsController.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-10-19.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import UIKit

protocol SettingsControllerCoordinatorDelegate: class {
    
}

class SettingsController: UIViewController {
    
    weak var coordinatorDelegate: SettingsControllerCoordinatorDelegate?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: Private Layout methods

private extension SettingsController {
    
    func configureView() {
        navigationItem.title = "Configurações"
        
        if #available(iOS 13.0, *) {
            tabBarItem = UITabBarItem(title: "Configurações", image: UIImage(systemName: "gear"), tag: 0)
        }
    }
    
    func configureLayout() {
        
    }
    
}
