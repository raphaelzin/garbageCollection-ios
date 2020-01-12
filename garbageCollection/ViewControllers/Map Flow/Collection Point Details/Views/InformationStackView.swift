//
//  InformationStackView.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2020-01-11.
//  Copyright © 2020 Raphael Inc. All rights reserved.
//

import UIKit

class InformationStackView: UIStackView {
    
    // MARK: Subviews
    
    private lazy var infoStack: UIStackView = {
        let stv = UIStackView()
        stv.axis = .vertical
        return stv
    }()
    
    private lazy var actionButton: UIButton = {
        return UIButton()
    }()
    
    private lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 16, weight: .semibold)
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private lazy var detailsLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 14, weight: .medium)
        lbl.numberOfLines = 0
        lbl.textColor = .systemGray
        return lbl
    }()
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configureLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: Configuration methods

extension InformationStackView {
    
    func configure(withTitle title: String, details: String, icon: UIImage? = nil) {
        titleLabel.text = title
        detailsLabel.text = details
        
        if let icon = icon {
            actionButton.setImage(icon, for: .normal)
            actionButton.isHidden = false
        } else {
            actionButton.isHidden = true
        }
    }
    
}

// MARK: View layout methods

private extension InformationStackView {
    
    func configureView() {
        axis = .horizontal
    }
    
    func configureLayout() {
        addArrangedSubview(infoStack)
        addArrangedSubview(actionButton)
        
        infoStack.addArrangedSubview(titleLabel)
        infoStack.addArrangedSubview(detailsLabel)
        
        actionButton.snp.makeConstraints { (make) in
            make.width.equalTo(20)
        }
    }
    
}
