//
//  AddressSelectionView.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-11-26.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import UIKit

class AddressSelectionView: UIView {
    
    // MARK: Subviews
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemGroupedBackground
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var manualEditBtn: UIButton = {
        let btn = UIButton(type: .custom)
        return btn
    }()
    
    private lazy var addressLabel: UILabel = {
        let l = UILabel()
        l.backgroundColor = .label
        return l
    }()
    
    private lazy var addressTextField: UITextField = {
        UITextField()
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: Private layout methods

private extension AddressSelectionView {
    
    func configureLayout() {
        addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            
        }
    }
    
}
