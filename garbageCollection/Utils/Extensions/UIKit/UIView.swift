//
//  UIView.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-11-25.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import UIKit

extension UIView {
    
    func allSubViewsOf<T: UIView>(type: T.Type) -> [T] {
        var all = [T]()
        func getSubview(view: UIView) {
            if let aView = view as? T {
                all.append(aView)
            }
            guard view.subviews.count>0 else { return }
            view.subviews.forEach { getSubview(view: $0) }
        }
        getSubview(view: self)
        return all
    }

}
