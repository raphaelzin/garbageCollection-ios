//
//  CollectionPointDetailsHeaderView.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2020-01-11.
//  Copyright © 2020 Raphael Inc. All rights reserved.
//

import UIKit

protocol CollectionPointDetailsHeaderViewDelegate: class {
    func didAskMoreInfo(on collectionPointType: CollectionPoint.PointType)
}

class CollectionPointDetailsHeaderView: UIView {
    
    // MARK: Attributes
    
    let type: CollectionPoint.PointType
    
    weak var delegate: CollectionPointDetailsHeaderViewDelegate?
    
    // MARK: Subviews
    
    private lazy var iconContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.backgroundColor = type.tintColor
        return view
    }()
    
    private lazy var iconImageView: UIImageView = {
        let iv = UIImageView(image: type.icon)
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 21, weight: .bold)
        lbl.numberOfLines = 0
        lbl.text = "\(type.shortName)"
        return lbl
    }()
    
    private lazy var knowMoreButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Saber mais sobre \(type.shortName)", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        btn.setTitleColor(.positiveBlue, for: .normal)
        btn.setTitleColor(UIColor.positiveBlue.withAlphaComponent(0.6), for: .highlighted)
        return btn
    }()
    
    private lazy var infoView: UIStackView = {
        let stv = UIStackView()
        stv.axis = .vertical
        stv.alignment = .leading
        return stv
    }()
    
    // MARK: Lifecycle
    
    init(type: CollectionPoint.PointType) {
        self.type = type
        super.init(frame: .zero)
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CollectionPointDetailsHeaderView {
    
    func configureView() {
        backgroundColor = .secondarySystemGroupedBackground
        layer.cornerRadius = 12
    }
    
    func configureLayout() {
        addSubview(iconContainer)
        addSubview(infoView)
        infoView.addArrangedSubview(titleLabel)
        infoView.addArrangedSubview(knowMoreButton)
        iconContainer.addSubview(iconImageView)
        
        iconContainer.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 56, height: 56))
            make.centerY.equalTo(self)
            make.leading.equalTo(self).offset(12)
        }
        
        iconImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(iconContainer).inset(14)
        }
        
        infoView.snp.makeConstraints { (make) in
            make.leading.equalTo(iconContainer.snp.trailing).offset(12)
            make.trailing.equalTo(snp.trailing).offset(-12)
            make.centerY.equalTo(self)
        }

    }
    
}
