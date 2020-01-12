//
//  InformationStackView.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2020-01-11.
//  Copyright © 2020 Raphael Inc. All rights reserved.
//

import UIKit

protocol InformationStackDelegate: class {
    func didRequestAction(for detailsType: CollectionPoint.DetailsListingType)
}

class InformationStackView: UIStackView {
    
    // MARK: Attributes
    
    var type: CollectionPoint.DetailsListingType!
    
    weak var delegate: InformationStackDelegate?
    
    // MARK: Subviews
    
    private lazy var infoStack: UIStackView = {
        let stv = UIStackView()
        stv.axis = .vertical
        return stv
    }()
    
    private lazy var actionButton: UIButton = {
        let btn = UIButton()
        btn.imageView?.contentMode = .scaleAspectFit
        btn.tintColor = .positiveBlue
        btn.addTarget(self, action: #selector(onActionTap), for: .touchUpInside)
        return btn
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

// MARK: Private selectors

private extension InformationStackView {
    
    @objc func onActionTap() {
        delegate?.didRequestAction(for: type)
    }
    
}

// MARK: Configuration methods

extension InformationStackView {
    
    func configure(with type: CollectionPoint.DetailsListingType) {
        self.type = type
        titleLabel.text = type.title
        detailsLabel.text = type.details
        
        if let icon = type.action?.icon {
            actionButton.setImage(icon.withRenderingMode(.alwaysTemplate), for: .normal)
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
        spacing = 2
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
