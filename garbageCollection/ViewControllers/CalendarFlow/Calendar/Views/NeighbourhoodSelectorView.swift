//
//  NeighbourhoodSelectorView.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-10-19.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import UIKit

protocol NeighbourhoodSelectorViewDelegate: class {
    func didRequestNeighbourhoodSelection()
}

class NeighbourhoodSelectorView: UIView {
    
    // Attributes
    
    weak var delegate: NeighbourhoodSelectorViewDelegate?
    
    // Subviews
    
    private lazy var leftLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.text = "Bairro"
        return label
    }()
    
    private lazy var neighbourhoodNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.text = "Centro"
        
        return label
    }()
    
    private lazy var chevronImageView: UIImageView = {
        let iv = UIImageView()
        iv.tintColor = .black
        if #available(iOS 13.0, *) {
            iv.image = UIImage(systemName: "chevron.right")
        }
        return iv
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondaryLightGray
        return view
    }()
    
    // Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureLayout()
        setupGestures()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: Public configuration methods

extension NeighbourhoodSelectorView {
    
    func configure() {
        
    }
    
}

// MARK: Private selectors

private extension NeighbourhoodSelectorView {
    
    @objc func onViewTap() {
        delegate?.didRequestNeighbourhoodSelection()
    }
    
}

// MARK: Private methods

private extension NeighbourhoodSelectorView {
    
    func setupGestures() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onViewTap)))
    }
    
}

 // MARK: Private layout methods

private extension NeighbourhoodSelectorView {
    
    func configureLayout() {
        addSubview(leftLabel)
        leftLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.leading.equalTo(self).offset(16)
        }
        
        addSubview(chevronImageView)
        chevronImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.trailing.equalTo(self).offset(-14)
        }
        
        addSubview(neighbourhoodNameLabel)
        neighbourhoodNameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.trailing.equalTo(chevronImageView.snp.leading).offset(-8)
        }
        
        addSubview(separatorView)
        separatorView.snp.makeConstraints { (make) in
            make.leading.bottom.trailing.equalTo(self)
            make.height.equalTo(0.5)
        }
    }
    
}
