//
//  GCPaddingTextField.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-12-15.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import UIKit

class GCPaddingTextField: UITextField {

    var padding = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 6)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
}
