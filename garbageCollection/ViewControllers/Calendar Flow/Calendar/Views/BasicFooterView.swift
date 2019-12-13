//
//  BasicFooterView.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-12-12.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import UIKit

class BasicFooterView: UIView {
    
    // MARK: Subviews
    
    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 13, weight: .regular)
        lbl.textColor = .secondaryLabel
        lbl.numberOfLines = 0
        return lbl
    }()
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init with coder not implemented")
    }
    
}

// MARK: Private layout methods

private extension BasicFooterView {
    
    func configureLayout() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self).inset(16)
            make.top.bottom.equalTo(self).inset(8)
        }
    }
    
}
