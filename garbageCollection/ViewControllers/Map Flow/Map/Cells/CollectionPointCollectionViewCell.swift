//
//  CollectionPointCollectionViewCell.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-11-16.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import UIKit

protocol CollectionPointCollectionViewCellDelegate: class {
    func didRequestMoreDetails(from collectionPoint: CollectionPoint)
}

class CollectionPointCollectionViewCell: UICollectionViewCell {
    
    // MARK: Attributes
    
    weak var delegate: CollectionPointCollectionViewCellDelegate?
    
    private var collectionPoint: CollectionPoint! {
        didSet {
            titleLabel.text = collectionPoint.name ?? "Nome indisponível"
            detailsLabel.text = collectionPoint.address ?? "Endereço indisponível"
            if let type = collectionPoint.safeType {
                iconImageView.backgroundColor = type.tintColor
                iconImageView.image = type.icon
            }
        }
    }
    
    // MARK: Subviews
    
    private lazy var iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 12
        iv.contentMode = .center
        iv.tintColor = .white
        return iv
    }()
    
    private lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 2
        l.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return l
    }()
    
    private lazy var detailsLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.textColor = .lightText
        l.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        return l
    }()
    
    private lazy var moreDetailsButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        btn.setTitleColor(.positiveBlue, for: .normal)
        btn.setTitleColor(UIColor.positiveBlue.withAlphaComponent(0.6), for: .highlighted)
        btn.addTarget(self, action: #selector(onMoreDetailsTap), for: .touchUpInside)
        btn.setTitle("Saiba mais", for: .normal)
        return btn
    }()
    
    private lazy var containerView: UIView = {
        let v = UIView()
        v.backgroundColor = .systemBackground
        v.layer.cornerRadius = 10
        return v
    }()
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dropShadow()
    }
    
}

// MARK: Public cell configuration methods

extension CollectionPointCollectionViewCell {
    
    func configure(with collectionPoint: CollectionPoint) {
        self.collectionPoint = collectionPoint
    }
    
}

// MARK: Private layout methods

private extension CollectionPointCollectionViewCell {
    
    func configureLayout() {
        addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        containerView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 56, height: 56))
            make.top.equalTo(containerView).offset(18)
            make.leading.equalTo(containerView).offset(16)
        }
        
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconImageView)
            make.leading.equalTo(iconImageView.snp.trailing).offset(16)
            make.trailing.equalTo(containerView).offset(-16)
        }
        
        containerView.addSubview(detailsLabel)
        detailsLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
        }
        
        containerView.addSubview(moreDetailsButton)
        moreDetailsButton.snp.makeConstraints { (make) in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(detailsLabel.snp.bottom).offset(4)
            make.bottom.equalTo(containerView).offset(-18)
        }
    }
    
    /// Drop shadow for container view
    func dropShadow() {
        let shadowPath = UIBezierPath(roundedRect: containerView.frame, cornerRadius: 10).cgPath
        containerView.layer.shadowPath = shadowPath
        containerView.layer.shadowRadius = 4
        containerView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        containerView.layer.shadowOffset = CGSize(width: -8, height: -3)
        containerView.layer.shadowOpacity = 0.5
    }
    
}

// MARK: Private selectors

private extension CollectionPointCollectionViewCell {
    
    @objc func onMoreDetailsTap() {
        delegate?.didRequestMoreDetails(from: collectionPoint)
    }
    
}
