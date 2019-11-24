//
//  UITableViewCell.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-10-21.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import UIKit

extension UITableViewCell {
    static var defaultIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell {
    
    func configure(with configurator: UITableViewCellConfigurator) {
        textLabel?.text = configurator.title
        accessoryType = configurator.accessory
    }
    
}
