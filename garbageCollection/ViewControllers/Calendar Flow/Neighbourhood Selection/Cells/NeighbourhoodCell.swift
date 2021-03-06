//
//  NeighbourhoodCell.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-10-23.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import UIKit

class NeighbourhoodCell: UITableViewCell {
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: Selection management

extension NeighbourhoodCell {
    
}

// MARK: Public configuration methods

extension NeighbourhoodCell {
    
    func configure(with title: String) {
        self.nameLabel.text = title
    }
    
}

// MARK: Private layout methods

private extension NeighbourhoodCell {
    
    func configureView() {
        separatorInset = .init(top: 0, left: 16, bottom: 0, right: 0)
    }
    
    func configureLayout() {
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(self).inset(UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0))
            make.height.equalTo(52)
        }
    }
    
}
