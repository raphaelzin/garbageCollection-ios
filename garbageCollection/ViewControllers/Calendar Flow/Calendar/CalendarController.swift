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
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.tableFooterView = UIView()
        tv.separatorStyle = .none
        tv.showsVerticalScrollIndicator = false
        tv.keyboardDismissMode = .interactive
        
        if #available(iOS 13, *) {
            tv.contentInset = UIEdgeInsets(top: 8 + kHeaderHeight, left: 0, bottom: 0, right: 0)
        } else {
            tv.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        }
        
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
        if #available(iOS 13, *) {
            bindViewModelState()
        }
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
            let weekyCollection = fullSchedule?.weeklyCollection ?? []
            return weekyCollection.isEmpty ? [] : [GenericSection(items: weekyCollection, header: "")]
        }
        .bind(to: tableView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)
        
        Observable
            .zip(tableView.rx.itemSelected, tableView.rx.modelSelected(WeekDayCollectionSchedule.self))
            .subscribe(onNext: { [weak self] (indexPath, collectionSchedule) in
                self?.tableView.deselectRow(at: indexPath, animated: true)
                self?.alert(for: collectionSchedule)
            }).disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    func bindSelectedNeighbourhood() {
        viewModel
            .selectedNeighbourhoodObservable
            .subscribe(onNext: { [weak self] (neighbourhood) in
                self?.updateTableViewBackgroud(showPlaceholder: neighbourhood == nil)
                self?.neighbourhoodSelector.configure(with: neighbourhood?.name ?? "Selecionar")
            }).disposed(by: disposeBag)
    }
    
    func bindViewModelState() {
        viewModel
            .state
            .map { $0 == .idle }
            .observeOn(MainScheduler.asyncInstance)
            .asDriver(onErrorJustReturn: true)
            .drive(activityIndicator.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    func bindBellState() {
        
        viewModel
            .selectedNeighbourhoodObservable
            .map { $0 != nil }
            .subscribe(onNext: { [weak self] (hasNeighbourhoodSelected) in
                self?.navigationItem.rightBarButtonItem?.isEnabled = hasNeighbourhoodSelected
            }).disposed(by: disposeBag)
        
        Observable
            .combineLatest(InstallationManager.shared.notificationsEnabled,
                           viewModel.selectedNeighbourhoodObservable)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (_) in
                let image = UIImage(symbol: self!.viewModel.areNotificationsActive ? "bell.slash" : "bell")
                self?.navigationItem.rightBarButtonItem?.image = image
            }).disposed(by: disposeBag)
    }

}

// MARK: TableView delegate

extension CalendarController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let disclaimer = "Este calendário é referente a coleta municipal do bairro selecionado. Caso você more em um condominio ou prédio talvez as datas sejam diferentes."
        
        let footerView = BasicFooterView()
        footerView.titleLabel.text = disclaimer
        return footerView
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
    
    func updateTableViewBackgroud(showPlaceholder: Bool) {
        if !showPlaceholder {
            tableView.backgroundView = nil
            return
        }
        let text = "Selecione um bairro para ver seu calendário de coleta."
        let view = TableViewPlaceholderView(configuration: .init(image: #imageLiteral(resourceName: "neighbourhoods"), text: text))
        view.frame = tableView.bounds
        tableView.backgroundView = view
    }
    
    func alert(for collectionSchedule: WeekDayCollectionSchedule) {
        let date = collectionSchedule.nextCollectionDate()
        let time = collectionSchedule.schedule.description.lowercased()
        let message = "A próxima coleta \(date.weekDay.fullname) será \(time), no dia \(date.formatted(as: .day)) de \(date.formatted(as: .month))"
        
        simpleAlert(withTitle: "Próxima coleta \(date.weekDay.fullname)",
                    message: message,
                    btnTitle: "Entendi")
    }
    
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
        let image = UIImage(symbol: viewModel.areNotificationsActive ? "bell.slash" : "bell" )
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image,
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(onBellTap))
        
        tabBarItem = UITabBarItem(title: "Calendário", image: UIImage(symbol: "calendar"), tag: 0)
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
        
        if #available(iOS 13, *) {
            view.addSubview(activityIndicator)
            activityIndicator.snp.makeConstraints { (make) in
                make.center.equalTo(view)
            }
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
                guard status != .authorized || Installation.current()?.deviceToken == nil else {
                    return .just(true)
                }
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
