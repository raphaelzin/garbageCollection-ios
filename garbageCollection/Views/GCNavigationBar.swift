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
        titleTextAttributes = [.foregroundColor: UIColor.white]//, .font: Fonts.Nunito.bold.size(18)]
        largeTitleTextAttributes = [.foregroundColor: UIColor.white]//, .font: Fonts.Nunito.bold.size(34)]
        
        tintColor = .white
        barTintColor = .defaultBlue
        
        shadowImage = UIImage()
        isTranslucent = false
    }
}
