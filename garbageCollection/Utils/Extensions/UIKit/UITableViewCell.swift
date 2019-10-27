//
//  UITableViewCell.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-10-21.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import UIKit

public extension UITableViewCell {
    static var defaultIdentifier: String {
        return String(describing: self)
    }
}
