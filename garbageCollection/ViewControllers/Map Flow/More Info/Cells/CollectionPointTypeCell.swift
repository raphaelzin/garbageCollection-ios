//
//  CollectionPointTypeCell.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-12-30.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import UIKit

class CollectionPointTypeCell: UITableViewCell {
    
    // MARK: Subviews
    
    private lazy var imageViewContainer: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 8
        return v
    }()
    
    private lazy var iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private lazy var nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 16, weight: .medium)
        lbl.textColor = .gray
        lbl.numberOfLines = 0
        return lbl
    }()
    
    // MARK: Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CollectionPointTypeCell {
    
    func configure(with type: CollectionPoint.PointType) {
        imageViewContainer.backgroundColor = type.tintColor
        iconImageView.image = type.icon
        nameLabel.text = type.fullName
    }
    
}

// MARK: Private configuration methods

private extension CollectionPointTypeCell {
    
    func configureView() {
        accessoryType = .disclosureIndicator
    }
    
    func configureLayout() {
        addSubview(nameLabel)
        addSubview(imageViewContainer)
        imageViewContainer.addSubview(iconImageView)
        
        imageViewContainer.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 32, height: 32))
            make.centerY.equalTo(self)
            make.leading.equalTo(self).offset(16)
        }
        
        iconImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(imageViewContainer).inset(7)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(imageViewContainer.snp.trailing).offset(12)
            make.trailing.equalTo(self)
            make.top.bottom.equalTo(self).inset(6)
            make.height.greaterThanOrEqualTo(38)
        }
    }
    
}
