//
//  UIColor.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-10-19.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import UIKit

extension UIColor {
    
    /// HEX: #3771C9
    @nonobjc class var defaultBlue: UIColor {
        return UIColor(red: 55.0 / 255.0, green: 113.0 / 255.0, blue: 201.0 / 255.0, alpha: 0.94)
    }
    
    /// HEX: #3F61AE
    @nonobjc class var darkerBlue: UIColor {
      return UIColor(red: 63.0 / 255.0, green: 97.0 / 255.0, blue: 174.0 / 255.0, alpha: 1.0)
    }
    
    // HEX: #6B9EEA
    @nonobjc class var lighterBlue: UIColor {
      return UIColor(red: 107.0 / 255.0, green: 158.0 / 255.0, blue: 234.0 / 255.0, alpha: 1.0)
    }
    
    // HEX: #979797
    @nonobjc class var secondaryLightGray: UIColor {
      return UIColor(white: 151.0 / 255.0, alpha: 0.37)
    }

}
