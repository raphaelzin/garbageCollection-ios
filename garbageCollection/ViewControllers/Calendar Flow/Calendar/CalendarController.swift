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
import SnapKit

protocol CalendarControllerCoordinatorDelegate: class {
    func didRequestNeighbourhoodSelection(from controller: CalendarController)
}

class CalendarController: GCViewModelController<CalendarViewModelType> {
    
    // Attributes
    
    weak var coordinatorDelegate: CalendarControllerCoordinatorDelegate?
    
    private var dataSource: RxTableViewSectionedAnimatedDataSource<GenericSection<WeekDayCollectionSchedule>>!
    
    private let disposeBag = DisposeBag()
    
    private var headerTopConstraint: Constraint?
    
    private let kHeaderHeight: CGFloat = 40
    
    // Subviews

    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.tableFooterView = UIView()
        tv.separatorStyle = .none
        tv.showsVerticalScrollIndicator = false
        tv.keyboardDismissMode = .interactive
        tv.contentInset = UIEdgeInsets(top: 8 + kHeaderHeight, left: 0, bottom: 0, right: 0)
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
    
    // MARK: Lifecycle

    override init(viewModel: CalendarViewModelType) {
        super.init(viewModel: viewModel)
        
        configureLayout()
        configureView()
        
        bindTableView()
        bindSelectedNeighbourhood()
        bindViewModelState()
        bindBellState()
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
            [GenericSection(items: fullSchedule?.weeklyCollection ?? [], header: "")]
        }
        .bind(to: tableView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)
        
        tableView.rx.itemSelected.bind { [weak tableView] (indexPath) in
            tableView?.deselectRow(at: indexPath, animated: true)
        }.disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    func bindSelectedNeighbourhood() {
        viewModel.selectedNeighbourhoodObservable.subscribe(onNext: { [weak neighbourhoodSelector] (neighbourhood) in
            neighbourhoodSelector?.configure(with: neighbourhood?.name ?? "Selecionar")
            }).disposed(by: disposeBag)
    }
    
    func bindViewModelState() {
        viewModel
            .state
            .map { $0 == .idle }
            .observeOn(MainScheduler.asyncInstance)
            .asDriver(onErrorJustReturn: false)
            .drive(self.activityIndicator.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    func bindBellState() {
        
        viewModel
            .selectedNeighbourhoodObservable
            .map { $0 != nil }
            .subscribe(onNext: { [weak self] (hasNeighbourhoodSelected) in
                self?.navigationItem.rightBarButtonItem?.isEnabled = hasNeighbourhoodSelected
            }).disposed(by: disposeBag)
        
        viewModel
            .notificationsActiveRelay
            .map { UIImage(systemName: $0 ? "bell.slash" : "bell" ) }
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] (image) in
                self?.navigationItem.rightBarButtonItem?.image = image
            }).disposed(by: disposeBag)
    }

}

// MARK: TableView delegate

extension CalendarController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let disclaimer = "Este calendário é referente a coleta municipal do bairro selecionado. Caso você more em um condominio ou prédio talvez as datas sejam diferentes."
        
        let header = BasicFooterView()
        header.titleLabel.text = disclaimer
        return header
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y + scrollView.contentInset.top
        
        if yOffset < 0 {
            headerTopConstraint?.update(offset: abs(yOffset))
        } else if yOffset >= 0 {
            headerTopConstraint?.update(offset: 0)
        }
    }
    
}

// MARK: Private methods

private extension CalendarController {
    
    func promptWillRemoveDefaultNeighbourhood() {
        let alert = UIAlertController(title: "Atenção",
                                      message: "Tem certeza que você quer desativar as notificações sobre coletas?",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Desativar", style: .destructive, handler: { _ in
            self.viewModel.bellTapped()
        }))
        
        present(alert, animated: true)

    }
    
    func promptWillDefineDefaultNeighbourhood() {
        let alert = UIAlertController(title: "Atenção",
                                      message: "Tem certeza que você quer ativar as notificações sobre coletas para este bairro?",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Ativar notificações", style: .default, handler: { _ in
            self.viewModel.bellTapped()
        }))
        
        present(alert, animated: true)
    }
    
    func promptNotificationsDisabled() {
        let alert = UIAlertController(title: "Atenção",
                                      message: "As notificações foram desativadas, você pode ativar novamente nas suas configurações",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Configurações", style: .default, handler: { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString),
                UIApplication.shared.canOpenURL(settingsUrl) else { return }
            
            UIApplication.shared.open(settingsUrl)
        }))
        
        present(alert, animated: true)
    }
    
}

// MARK: Private Layout methods

private extension CalendarController {
    
    func configureView() {
        navigationItem.title = "Calendário de coleta"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "bell"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(onBellTap))
        
        if #available(iOS 13.0, *) {
            tabBarItem = UITabBarItem(title: "Calendário", image: UIImage(systemName: "calendar"), tag: 0)
        }
    }
    
    func configureLayout() {
        
        view.addSubview(tableView)
        view.addSubview(neighbourhoodSelector)
        neighbourhoodSelector.snp.makeConstraints { (make) in
            self.headerTopConstraint = make.top.equalTo(view.safeAreaLayoutGuide).constraint
            make.leading.trailing.equalTo(view)
            make.height.equalTo(kHeaderHeight)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { (make) in
            make.center.equalTo(view)
        }
    }
    
}

// MARK: Private selectors

private extension CalendarController {
    
    @objc func onBellTap() {
        UNUserNotificationCenter.current()
            .rx
            .getAuthorizationStatus()
            .flatMap { (status) -> Single<Bool> in
                guard status != .authorized else { return .just(true) }
                return UNUserNotificationCenter.current().rx.requestAuthorization(options: [.badge, .alert, .sound])
            }
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { (granted) in
                guard granted else {
                    self.promptNotificationsDisabled()
                    return
                }
                
                if self.viewModel.areNotificationsActive {
                    self.promptWillRemoveDefaultNeighbourhood()
                } else {
                    self.promptWillDefineDefaultNeighbourhood()
                }
                
            })
            .disposed(by: disposeBag)
    }
    
}

// MARK: Delegate conformances

extension CalendarController: NeighbourhoodSelectorViewDelegate {
    
    func didRequestNeighbourhoodSelection() {
        coordinatorDelegate?.didRequestNeighbourhoodSelection(from: self)
    }
    
}

extension CalendarController: NeighbourhoodSelectorDelegate {
    
    func didSelect(neighbourhood: Neighbourhood) {
        viewModel.select(neighbourhood: neighbourhood)
    }
    
}
