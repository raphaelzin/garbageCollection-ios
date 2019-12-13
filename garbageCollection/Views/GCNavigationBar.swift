//
//  GCNavigationBar.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-10-19.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import UIKit

class GCNavigationBar: UINavigationBar {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAppearence()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupAppearence() {
        titleTextAttributes = [.foregroundColor: UIColor.white]
        largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        tintColor = .white
        barTintColor = .defaultBlue
        
        shadowImage = UIImage()
        isTranslucent = false
        
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = .defaultBlue
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            
            scrollEdgeAppearance = appearance
            standardAppearance = appearance
            compactAppearance = appearance
        }
        
    }
}
