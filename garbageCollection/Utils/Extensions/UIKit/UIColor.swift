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
    
    /// HEX: #6B9EEA
    @nonobjc class var lighterBlue: UIColor {
      return UIColor(red: 107.0 / 255.0, green: 158.0 / 255.0, blue: 234.0 / 255.0, alpha: 1.0)
    }
    
    /// HEX: #979797
    @nonobjc class var secondaryLightGray: UIColor {
      return UIColor(white: 151.0 / 255.0, alpha: 0.37)
    }
    
    /// HEX: #8D8D8D
    @nonobjc class var brownGrey: UIColor {
      return UIColor(white: 141.0 / 255.0, alpha: 1.0)
    }

    /// HEX: #F83A3A
    @nonobjc class var orangeyRed: UIColor {
      return UIColor(red: 248.0 / 255.0, green: 58.0 / 255.0, blue: 58.0 / 255.0, alpha: 1.0)
    }
    
    /// HEX: #FFCB00
    @nonobjc class var marigold: UIColor {
      return UIColor(red: 1.0, green: 203.0 / 255.0, blue: 0.0, alpha: 1.0)
    }

    /// HEX: #2EC862
    @nonobjc class var coolGreen: UIColor {
      return UIColor(red: 46.0 / 255.0, green: 200.0 / 255.0, blue: 98.0 / 255.0, alpha: 1.0)
    }

    /// HEX: #5EA9FF
    @nonobjc class var skyBlue: UIColor {
      return UIColor(red: 94.0 / 255.0, green: 169.0 / 255.0, blue: 1.0, alpha: 1.0)
    }

    /// HEX: #54A0FF
    @nonobjc class var positiveBlue: UIColor {
      return UIColor(red: 84 / 255.0, green: 160 / 255.0, blue: 1.0, alpha: 1.0)
    }
    
    /// HEX: #EFEFF4
    @nonobjc class var veryLightGray: UIColor {
        return UIColor(red: 239 / 255.0, green: 239 / 255.0, blue: 244 / 255.0, alpha: 1.0)
    }
    
    /// HEX: #363F41
    @nonobjc class var charcoalGrey: UIColor {
        return UIColor(red: 53 / 255.0, green: 63 / 255.0, blue: 65 / 255.0, alpha: 1.0)
    }
    
    /// HEX: #00C0E1
    @nonobjc class var eletronicCyan: UIColor {
        return UIColor(red: 0 / 255.0, green: 192 / 255.0, blue: 255 / 255.0, alpha: 1.0)
    }
    
    // MARK: Safe system colors
    
    @nonobjc class var safeSystemBackground: UIColor {
        if #available(iOS 13.0, *) {
            return .systemBackground
        } else {
            return .white
        }
    }
    
    @nonobjc class var safeLabel: UIColor {
        if #available(iOS 13.0, *) {
            return .label
        } else {
            return .black
        }
    }
    
    @nonobjc class var safeSecondaryLabel: UIColor {
        if #available(iOS 13.0, *) {
            return .secondaryLabel
        } else {
            return UIColor(red: 60/255, green: 60/255, blue: 67/255, alpha: 0.6)
        }
    }

    @nonobjc class var safeSeparator: UIColor {
        if #available(iOS 13.0, *) {
            return .separator
        } else {
            return UIColor(red: 60/255, green: 60/255, blue: 67/255, alpha: 0.29)
        }
    }

    @nonobjc class var safeSecondarySystemGroupedBackground: UIColor {
        if #available(iOS 13.0, *) {
            return .secondarySystemGroupedBackground
        } else {
            return .white
        }
    }
    
    @nonobjc class var safeSystemGroupedBackground: UIColor {
        if #available(iOS 13.0, *) {
            return .systemGroupedBackground
        } else {
            return UIColor(red: 242/255, green: 242/255, blue: 247/255, alpha: 1)
        }
    }
    
    @nonobjc class var safePlaceholderText: UIColor {
        if #available(iOS 13.0, *) {
            return .placeholderText
        } else {
            return UIColor(red: 60/255, green: 60/255, blue: 67/255, alpha: 0.3)
        }
    }
    
}
