//
//  UIFont.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2020-07-03.
//  Copyright © 2020 Raphael Inc. All rights reserved.
//

import UIKit

extension UIFont {
    @available (iOS 13.0, *)
    class func roundedFont(ofSize fontSize: CGFloat, weight: UIFont.Weight) -> UIFont {
        if let descriptor = UIFont.systemFont(ofSize: fontSize, weight: weight).fontDescriptor.withDesign(.rounded) {
            return UIFont(descriptor: descriptor, size: fontSize)
        } else {
            return .systemFont(ofSize: fontSize, weight: weight)
        }
    }
    
}
