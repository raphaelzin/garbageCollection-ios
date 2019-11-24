//
//  UITableViewCellConfigurator.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-11-23.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import UIKit

protocol UITableViewCellConfigurator {
    var accessory: UITableViewCell.AccessoryType { get }
    var title: String { get }
}
