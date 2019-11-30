//
//  PaddingLabel.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-11-28.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import UIKit

class PaddingLabel: UILabel {
    
    var topInset: CGFloat = 5.0
    var bottomInset: CGFloat = 5.0
    var leftInset: CGFloat = 12.0
    var rightInset: CGFloat = 12.0

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
    
    
}
