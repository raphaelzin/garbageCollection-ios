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
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.keyboardDismissMode = .interactive
        tableView.registerCell(cellClass: NeighbourhoodCell.self)
        return tableView
    }()
    
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar(frame: .zero)
        sb.placeholder = "Procurar bairro"
        sb.searchTextField.backgroundColor = .white
        
        return sb
    }()
    
    lazy var backgroundLabel: UILabel = {
        let label = UILabel()
        label.text = "Não foram encontrados bairros"
        label.textAlignment = .center
        return label
    }()
    
    // Lifecycle
    
    override init(viewModel: NeighbourhoodSelectionViewModelType) {
        super.init(viewModel: viewModel)
        
        configureView()
        configureLayout()
        configureNavBar()
        
        bindSearchResults()
        bindTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.titleView = searchBar
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
        searchBar.rx.text.orEmpty
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe { [weak viewModel] (event) in
                guard let term = event.element else { return }
                viewModel?.fetchNeighbourhoods(with: term)
            }.disposed(by: disposeBag)
    }
    
    func bindTableView() {
        
        // Configure each cell according to the item RxDataSources
        dataSource = RxTableViewSectionedAnimatedDataSource<GenericSection<Neighbourhood>>(
            configureCell: { _, tableView, indexPath, item in
                let cell = tableView.dequeue(cellClass: NeighbourhoodCell.self, indexPath: indexPath)
                cell.configure(with: item.name ?? "")
                return cell
        })
        
        // Binds the countrys to the tableView
        viewModel.neighbourhoods.map { [weak self] in
            self?.tableView.backgroundView = $0.isEmpty ? self!.backgroundLabel : nil
            return [GenericSection(items: $0, header: "")]
            }.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        // Bind the events itemSelected and modelSelected so we can tell the delegates that we selected the country and should dismiss the vc
        Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(Neighbourhood.self)).bind { [weak self] indexPath, neighbourhood in
            self?.tableView.deselectRow(at: indexPath, animated: true)
            self?.searchBar.resignFirstResponder()
            self?.delegate?.didSelect(neighbourhood: neighbourhood)
            self?.coordinatorDelegate?.didRequestDismiss(from: self!)
            }.disposed(by: disposeBag)
    }
    
}

// MARK: Private layout methods

private extension NeighbourhoodSelectionController {
    
    func configureView() {
        view.backgroundColor = .white
    }
    
    func configureLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaInsets)
        }
    }
    
    func configureNavBar() {
        searchBar.sizeToFit()
        searchBar.barTintColor = .clear
        searchBar.backgroundImage = UIImage()
        
    }
    
}
