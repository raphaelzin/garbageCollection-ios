//
//  CollectionPointDetails.swift
//  garbageCollection
//
// Created by Raphael Souza on 2020-01-11.
// Copyright © 2020 Raphael Inc. All rights reserved.
//

import UIKit

protocol CollectionPointDetailsCoordinatorDelegate: class {
    func didRequestDismiss(from controller: CollectionPointDetailsController)
    func didRequestMoreInfo(about type: CollectionPoint.PointType, from controller: UIViewController)
}

class CollectionPointDetailsController: GCViewModelController<CollectionPointDetailsViewModelType> {
    
    // MARK: Attributes
    
    weak var coordinatorDelegate: CollectionPointDetailsCoordinatorDelegate?
    
    // MARK: Subviews
    
    private lazy var scrollView = UIScrollView()
    
    private lazy var headerView: CollectionPointDetailsHeaderView = {
        let view = CollectionPointDetailsHeaderView(title: viewModel.collectionPoint.name ?? "",
                                                    type: viewModel.collectionPoint.safeType ?? .ecopoint)
        view.delegate = self
        return view
    }()
    
    private lazy var detailsStackContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemGroupedBackground
        view.layer.cornerRadius = 12
        return view
    }()
    
    private lazy var detailsStack: UIStackView = {
        let stv = UIStackView()
        stv.axis = .vertical
        stv.spacing = 16
        return stv
    }()
    
    // MARK: Lifecycle
    
    override init(viewModel: CollectionPointDetailsViewModelType) {
        super.init(viewModel: viewModel)
        configureLayout()
        configureView()
        createDetails()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: Private layout methods

private extension CollectionPointDetailsController {
    
    func createDetails() {
        
        let detailsList = viewModel.collectionPoint.listedDetails
        
        for details in detailsList {
            let stack = InformationStackView()
            stack.delegate = self
            stack.configure(with: details)
            detailsStack.addArrangedSubview(stack)
        }
    }
    
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
        
        scrollView.addSubview(detailsStackContainer)
        detailsStackContainer.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(scrollView.contentLayoutGuide).inset(16)
            make.top.equalTo(headerView.snp.bottom).offset(18)
            make.bottom.equalTo(scrollView).offset(-20)
        }
        
        detailsStackContainer.addSubview(detailsStack)
        detailsStack.snp.makeConstraints { (make) in
            make.edges.equalTo(detailsStackContainer).inset(UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16))
        }
        
    }
    
    func configureView() {
        addDefaultShadow(to: headerView)
        addDefaultShadow(to: detailsStackContainer)
        
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

// MARK: Private methods

private extension CollectionPointDetailsController {
    
    func requestRoute() {
        
    }
    
    func requestCall() {
        
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
        coordinatorDelegate?.didRequestMoreInfo(about: collectionPointType, from: self)
    }
    
}

extension CollectionPointDetailsController: InformationStackDelegate {
    
    func didRequestAction(for detailsType: CollectionPoint.DetailsListingType) {
        switch detailsType.action {
        case .call: requestCall()
        case .route: requestRoute()
        default:
            print("Action unavailable")
        }
    }
    
}
