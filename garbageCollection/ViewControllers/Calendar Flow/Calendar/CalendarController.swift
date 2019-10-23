//
//  CalendarController.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-10-19.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

protocol CalendarControllerCoordinatorDelegate: class {
    
}

class CalendarController: GCViewModelController<CalendarViewModelType> {
    
    // Attributes
    
    weak var coordinatorDelegate: CalendarControllerCoordinatorDelegate?
    
    private var dataSource: RxTableViewSectionedAnimatedDataSource<GenericSection<WeekDayCollectionSchedule>>!
    
    let disposeBag = DisposeBag()
    
    // Subviews

    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.tableFooterView = UIView()
        tv.separatorStyle = .none
        tv.showsVerticalScrollIndicator = false
        tv.keyboardDismissMode = .interactive
        tv.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        tv.registerCell(cellClass: ScheduledCollectionCell.self)
        return tv
    }()
    
    private lazy var neighbourhoodSelector: NeighbourhoodSelectorView = {
        let header = NeighbourhoodSelectorView()
        header.delegate = self
        return header
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView()
        ai.color = .defaultBlue
        ai.startAnimating()
        ai.isHidden = true
        return ai
    }()
    
    // Init

    override init(viewModel: CalendarViewModelType) {
        super.init(viewModel: viewModel)
        
        configureLayout()
        configureView()
        
        bindTableView()
        bindSelectedNeighbourhood()
        bindViewModelState()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: Private binding UI components

private extension CalendarController {
    
    func bindTableView() {
        dataSource = RxTableViewSectionedAnimatedDataSource<GenericSection<WeekDayCollectionSchedule>>(
            configureCell: { _, tableView, indexPath, item in
                let cell = tableView.dequeue(cellClass: ScheduledCollectionCell.self, indexPath: indexPath)
                cell.configure(with: item)
                return cell
        })
        
        viewModel.selectedCollectionSchedule.map { (fullSchedule) -> [GenericSection<WeekDayCollectionSchedule>] in
            return [GenericSection(items: fullSchedule?.weeklyCollection ?? [], header: "")]
        }
        .bind(to: tableView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)
        
        tableView.rx.itemSelected.bind { (indexPath) in
            self.tableView.deselectRow(at: indexPath, animated: true)
        }.disposed(by: disposeBag)
    }
    
    func bindSelectedNeighbourhood() {
        viewModel.selectedNeighbourhoodObservable.subscribe(onNext: { (neighbourhood) in
            self.neighbourhoodSelector.configure(with: neighbourhood?.name ?? "Selecionar")
            }).disposed(by: disposeBag)
    }
    
    func bindViewModelState() {
        viewModel.state.bind { (state) in
            self.activityIndicator.isHidden = state == .idle
        }.disposed(by: disposeBag)
    }

}

// MARK: Private Layout methods

private extension CalendarController {
    
    func configureView() {
        navigationItem.title = "Calendário de coleta"
        
        if #available(iOS 13.0, *) {
            tabBarItem = UITabBarItem(title: "Calendário", image: UIImage(systemName: "calendar"), tag: 0)
        }
    }
    
    func configureLayout() {
        
        view.addSubview(neighbourhoodSelector)
        neighbourhoodSelector.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalTo(view)
            make.height.equalTo(40)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.leading.bottom.trailing.equalTo(view)
            make.top.equalTo(neighbourhoodSelector.snp.bottom)
        }
        
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { (make) in
            make.center.equalTo(view)
        }
    }
    
}

// MARK: Delegate conformances

extension CalendarController: NeighbourhoodSelectorViewDelegate {
    
    func didRequestNeighbourhoodSelection() {
        print(#function)
    }
    
}
