//
//  CollectionPointFilterController.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-10-27.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol CollectionPointFilterCoordinatorDelegate: class {
    func didRequestDismiss(from controller: CollectionPointFilterController)
}

protocol FilterSelectorDelegate: class {
    func didSelect(filters: [CollectionPoint.PointType])
}

class CollectionPointFilterController: GCViewModelController<CollectionPointFilterViewModelType> {
    
    // MARK: Attributes
    
    weak var coordinatorDelegate: CollectionPointFilterCoordinatorDelegate?
    
    weak var filterDelegate: FilterSelectorDelegate?
    
    // MARK: Private attributes
    
    private let disposeBag = DisposeBag()
    
    // MARK: Subviews
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.registerCell(cellClass: SelectableCell.self)
        tv.allowsMultipleSelection = true
        tv.tableFooterView = UIView()
        return tv
    }()
    
    // MARK: Lifecycle
    
    override init(viewModel: CollectionPointFilterViewModelType) {
        super.init(viewModel: viewModel)
        
        configureLayout()
        configureNavBar()
        bindTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: Private layout methods

private extension CollectionPointFilterController {
    
    func configureLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaInsets)
        }
    }
    
    func configureNavBar() {
        navigationItem.title = "Filtrar pontos de coleta"
        
        let filter = UIBarButtonItem(title: "Filtrar", style: .done, target: self, action: #selector(onFilterTap))
        navigationItem.rightBarButtonItem = filter
        
        if #available(iOS 13, *) { } else {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Fechar",
                                                               style: .plain,
                                                               target: self,
                                                               action: #selector(onCloseTap))
        }
    }
    
}

// MARK: Bindings

private extension CollectionPointFilterController {
    
    func bindTableView() {
        Observable
            .of(viewModel.collectionPointTypes)
            .bind(to: tableView.rx.items(cellIdentifier: SelectableCell.defaultIdentifier,
                                         cellType: SelectableCell.self)) { _, type, cell in
                cell.configure(with: type.fullName)
                cell.configure(selected: self.viewModel.selectedCollectionPoints.contains(type))
            }
            .disposed(by: disposeBag)
        
        tableView
            .rx
            .modelSelected(CollectionPoint.PointType.self)
            .subscribe(onNext: { (type) in
                self.viewModel.select(type: type)
            })
            .disposed(by: disposeBag)
        
        tableView
            .rx
            .modelDeselected(CollectionPoint.PointType.self)
            .subscribe(onNext: { (type) in
                self.viewModel.unselect(type: type)
            })
            .disposed(by: disposeBag)
        
        viewModel.collectionPointTypes.enumerated().filter { viewModel.selectedCollectionPoints.contains($0.element) }.forEach {
            let indexPath = IndexPath(row: $0.offset, section: 0)
            tableView.selectRow(at: IndexPath(row: $0.offset, section: 0), animated: false, scrollPosition: .none)
            (tableView.cellForRow(at: indexPath) as? SelectableCell)?.configure(selected: true)
        }
    }
    
}

// MARK: Private selectors

private extension CollectionPointFilterController {
    
    @objc func onFilterTap() {
        filterDelegate?.didSelect(filters: viewModel.selectedCollectionPoints)
        coordinatorDelegate?.didRequestDismiss(from: self)
    }
    
    @objc func onCloseTap() {
        coordinatorDelegate?.didRequestDismiss(from: self)
    }
    
}
