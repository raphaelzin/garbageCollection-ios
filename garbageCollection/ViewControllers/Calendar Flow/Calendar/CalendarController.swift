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
        return tv
    }()
    
    private lazy var neighbourhoodSelector: NeighbourhoodSelectorView = {
        let header = NeighbourhoodSelectorView()
        header.delegate = self
        return header
    }()
    
    // Init

    override init(viewModel: CalendarViewModelType) {
        super.init(viewModel: viewModel)
        
        configureLayout()
        configureView()
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
        
        viewModel.selectedNeighbourhoodObservable.map { (fullSchedule) -> [GenericSection<WeekDayCollectionSchedule>] in
            print("Event")
            return [GenericSection(items: fullSchedule, header: "")]
        }.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
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
        
    }
    
}

// MARK: Delegate conformances

extension CalendarController: NeighbourhoodSelectorViewDelegate {
    
    func didRequestNeighbourhoodSelection() {
        print(#function)
    }
    
}
