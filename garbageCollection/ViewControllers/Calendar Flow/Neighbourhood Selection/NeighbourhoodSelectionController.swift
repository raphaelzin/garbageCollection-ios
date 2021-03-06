//
//  NeighbourhoodSelectionController.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-10-23.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Firebase

protocol NeighbourhoodSelectionCoordenatorDelegate: class {
    func didRequestDismiss(from controller: NeighbourhoodSelectionController)
}

protocol NeighbourhoodSelectorDelegate: class {
    func didSelect(neighbourhood: Neighbourhood)
}

class NeighbourhoodSelectionController: GCViewModelController<NeighbourhoodSelectionViewModelType> {
    
    // Attributes
    
    private let disposeBag = DisposeBag()
    
    weak var coordinatorDelegate: NeighbourhoodSelectionCoordenatorDelegate?
    
    weak var delegate: NeighbourhoodSelectorDelegate?
    
    private var dataSource: RxTableViewSectionedAnimatedDataSource<GenericSection<Neighbourhood>>!
    
    // Subviews
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.keyboardDismissMode = .interactive
        tableView.tableFooterView = UIView()
        tableView.registerCell(cellClass: NeighbourhoodCell.self)
        return tableView
    }()
    
    private lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.searchBar.placeholder = "Buscar bairro"
        if #available(iOS 13.0, *) {
            sc.searchBar.searchTextField.backgroundColor = .safeSecondarySystemGroupedBackground
        } else {
            // Fallback on earlier versions
        }
        sc.obscuresBackgroundDuringPresentation = false
        return sc
    }()
    
    lazy var backgroundLabel: UILabel = {
        let label = UILabel()
        label.text = "Não foram encontrados bairros"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView()
        ai.color = .defaultBlue
        ai.startAnimating()
        ai.isHidden = true
        return ai
    }()

    // Lifecycle
    
    override init(viewModel: NeighbourhoodSelectionViewModelType) {
        super.init(viewModel: viewModel)

        configureView()
        configureLayout()
        configureNavBar()
        
        if #available(iOS 13, *) {
            bindSearchResults()
        }
        
        bindTableView()
        stateBinding()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundLabel.frame = tableView.frame
    }
    
}

// MARK: Private UI bindings

private extension NeighbourhoodSelectionController {
    
    func bindSearchResults() {
        searchController.searchBar.rx.text.orEmpty
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe { [weak viewModel] (event) in
                guard let term = event.element else { return }
                viewModel?.filter(with: term)
            }.disposed(by: disposeBag)
    }
    
    func bindTableView() {
        
        dataSource = RxTableViewSectionedAnimatedDataSource<GenericSection<Neighbourhood>>(
            configureCell: { _, tableView, indexPath, item in
                let cell = tableView.dequeue(cellClass: NeighbourhoodCell.self, indexPath: indexPath)
                cell.configure(with: item.name ?? "")
                return cell
        })
        
        Observable
            .combineLatest(viewModel.neighbourhoods, viewModel.state)
            .map { [weak self] (items, state) -> [GenericSection<Neighbourhood>] in
                self?.tableView.backgroundView = items.isEmpty && state == .idle ? self!.backgroundLabel : nil
                return [GenericSection(items: items, header: "")]
        }.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)

        Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(Neighbourhood.self)).bind { [weak self] indexPath, neighbourhood in
            self?.tableView.deselectRow(at: indexPath, animated: true)
            if #available(iOS 13, *) {
                self?.searchController.searchBar.resignFirstResponder()
            }
            
            Analytics.logTrackedEvent(.neighbourhoodSelection, parameters: ["selected": neighbourhood.name ?? ""])
            self?.delegate?.didSelect(neighbourhood: neighbourhood)
            self?.coordinatorDelegate?.didRequestDismiss(from: self!)
            }.disposed(by: disposeBag)
    }
    
    func stateBinding() {
        viewModel
            .state
            .map { $0 == .idle }
            .asDriver(onErrorJustReturn: false)
            .drive(self.activityIndicator.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
}

// MARK: Private layout methods

private extension NeighbourhoodSelectionController {
    
    func configureView() {
        view.backgroundColor = .safeSystemBackground
        extendedLayoutIncludesOpaqueBars = true
    }
    
    func configureLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaInsets)
        }
        
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { (make) in
            make.center.equalTo(view)
        }
    }
    
    func configureNavBar() {
        navigationItem.title = "Bairros"
        navigationItem.hidesSearchBarWhenScrolling = false
        
        if #available(iOS 13, *) {
            navigationItem.searchController = searchController
        }
    }
    
}
