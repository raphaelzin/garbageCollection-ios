//
//  NeighbourhoodSelectorView.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-10-19.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import UIKit

class NeighbourhoodSelectorView: UIView {
    
    private lazy var leftLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private lazy var neighbourhoodNameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var chevronImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "chevron.right")
        return iv
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondaryLightGray
        return view
    }()
    
}

 // MARK: Private layout methods

private extension NeighbourhoodSelectorView {
    
    func configureLayout() {
        
    }
    
}
