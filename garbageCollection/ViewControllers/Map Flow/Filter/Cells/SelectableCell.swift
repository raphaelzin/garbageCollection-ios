//
//  SelectableCell.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-11-06.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import UIKit

class SelectableCell: UITableViewCell {
    
    // MARK: Subviews
    
    private lazy var label: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        return l
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        accessoryType = selected ? .checkmark : .none
    }

}

// MARK: Public configuration methods

extension SelectableCell {
    
    func configure(with title: String) {
        label.text = title
    }
    
    func configure(selected: Bool) {
        setSelected(selected, animated: true)
        accessoryType = selected ? .checkmark : .none
        isSelected = selected
    }
}

// MARK: Private layout methods

private extension SelectableCell {
    
    func configureView() {
        selectionStyle = .none
    }
    
    func configureLayout() {
        addSubview(label)
        label.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self).inset(8)
            make.height.greaterThanOrEqualTo(40)
            make.leading.equalTo(self).offset(16)
            make.trailing.equalTo(self).offset(-36)
        }
    }
    
}
