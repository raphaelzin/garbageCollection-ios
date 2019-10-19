//
//  UIImage.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-10-19.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import UIKit

extension UIImage {
    
    
    /// Helper for SF Symbols
    @available(iOS 13.0, *)
    func image(for sfSymbol: String, weight: UIImage.SymbolWeight) -> UIImage? {
        let smallConfiguration = UIImage.SymbolConfiguration(weight: weight)
        return UIImage(systemName: sfSymbol, withConfiguration: smallConfiguration)
    }
    
}
