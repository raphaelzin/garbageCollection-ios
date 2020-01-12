//
//  CollectionPointDetails.swift
//  garbageCollection
//
// Created by Raphael Souza on 2020-01-11.
// Copyright © 2020 Raphael Inc. All rights reserved.
//

import UIKit

protocol CollectionPointDetailsControllerCoordinatorDelegate: class {
    func didRequestDismiss(from controller: UIViewController)
}

class CollectionPointDetailsController: UIViewController {
    
    // MARK: Attributes
    
    weak var coordinatorDelegate: CollectionPointDetailsControllerCoordinatorDelegate?
    
    // MARK: Subviews
    
    private lazy var scrollView = UIScrollView()
    
    private lazy var headerView: CollectionPointDetailsHeaderView = {
        let view = CollectionPointDetailsHeaderView(type: .ecopoint)
        view.delegate = self
        return view
    }()
    
    // MARK: Lifecycle
    
    init() {
        super.init(nibName: nil, bundle: nil)
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: Private layout methods

private extension CollectionPointDetailsController {
    
    func configureLayout() {
        view.addSubview(scrollView)
        
        scrollView.contentLayoutGuide.snp.makeConstraints { (make) in
            make.width.equalTo(view)
        }
        
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        scrollView.addSubview(headerView)
        headerView.snp.makeConstraints { (make) in
            make.height.equalTo(80)
            make.leading.top.trailing.equalTo(scrollView.contentLayoutGuide).inset(16)
        }
    }
    
    func configureView() {
        addDefaultShadow(to: headerView)
        
        view.backgroundColor = .systemGroupedBackground
        navigationItem.title = "Ecoponto"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Fechar",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(onCloseTap))
    }
    
    func addDefaultShadow(to view: UIView) {
        view.layer.shadowRadius = 4
        view.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowOpacity = 0.2
    }
    
}

// MARK: Private selectors

private extension CollectionPointDetailsController {
    
    @objc func onCloseTap() {
        coordinatorDelegate?.didRequestDismiss(from: self)
    }
    
}

// MARK: Delegate conformances

extension CollectionPointDetailsController: CollectionPointDetailsHeaderViewDelegate {
    
    func didAskMoreInfo(on collectionPointType: CollectionPoint.PointType) {
        print(collectionPointType)
    }
    
}
