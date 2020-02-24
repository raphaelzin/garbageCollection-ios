//
//  NeighbourhoodSelectorView.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-10-19.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import UIKit
import SnapKit

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
        label.text = "Selecionar"
        return label
    }()
    
    private lazy var chevronImageView: UIImageView = {
        let iv = UIImageView()
        iv.tintColor = .safeLabel
        if #available(iOS 13.0, *) {
            iv.image = UIImage(symbol: "chevron.right")
        }
        return iv
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .safeSeparator
        return view
    }()
    
    // Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
        configureLayout()
        setupGestures()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: Public configuration methods

extension NeighbourhoodSelectorView {
    
    func configure(with neighbourhoodName: String) {
        neighbourhoodNameLabel.text = neighbourhoodName
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
    
    func configureView() {
        backgroundColor = .safeSystemBackground
    }
    
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
