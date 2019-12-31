//
//  CollectionPointInfoController.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-12-30.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import UIKit

class CollectionPointInfoController: UIViewController {
    
    // MARK: Attributes
    
    private let collectionPointType: CollectionPoint.PointType
    
    // MARK: Subviews
    
    private lazy var scrollView = UIScrollView()
    
    private lazy var headerContainer = UIView()
    
    private lazy var bodyLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Test!"
        return lbl
    }()
    
    private lazy var iconContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.backgroundColor = collectionPointType.tintColor
        return view
    }()
    
    private lazy var iconImageView: UIImageView = {
        let iv = UIImageView(image: collectionPointType.icon)
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 21, weight: .bold)
        lbl.numberOfLines = 0
        lbl.text = collectionPointType.fullName
        return lbl
    }()
    
    // MARK: Lifecycle
    
    init(type: CollectionPoint.PointType) {
        self.collectionPointType = type
        super.init(nibName: nil, bundle: nil)
        configureView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: Private layout methods

private extension CollectionPointInfoController {
    
    func configureView() {
        navigationItem.title = collectionPointType.shortName
        view.backgroundColor = .systemBackground
    }
    
    func configureLayout() {
        view.addSubview(scrollView)
        
        scrollView.addSubview(headerContainer)
        scrollView.addSubview(bodyLabel)
        
        headerContainer.addSubview(iconContainer)
        headerContainer.addSubview(titleLabel)
        
        iconContainer.addSubview(iconImageView)
        
        scrollView.contentLayoutGuide.snp.makeConstraints { (make) in
            make.width.equalTo(view)
        }
        
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        headerContainer.snp.makeConstraints { (make) in
            make.leading
                .top
                .trailing
                .equalTo(scrollView.contentLayoutGuide)
                .inset(UIEdgeInsets(top: 16, left: 24, bottom: 0, right: 24))
            
            make.height.equalTo(56)
        }
        
        iconContainer.snp.makeConstraints { (make) in
            make.leading.top.bottom.equalTo(headerContainer)
            make.width.equalTo(56)
        }
        
        iconImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(iconContainer).inset(14)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.trailing.bottom.equalTo(headerContainer)
            make.leading.equalTo(iconContainer.snp.trailing).offset(16)
        }
        
        bodyLabel.snp.makeConstraints { (make) in
            make.top.equalTo(headerContainer.snp.bottom).offset(16)
            make.leading
                .trailing
                .bottom
                .equalTo(scrollView.contentLayoutGuide)
                .inset(UIEdgeInsets(top: 0, left: 24, bottom: 16, right: 24))
        }
        
    }
    
}
