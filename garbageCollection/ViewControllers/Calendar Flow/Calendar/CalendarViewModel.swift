//
//  CalendarViewModel.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-10-19.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol CalendarViewModelType: class {
    // Bindable attributes
    var selectedNeighbourhoodObservable: Observable<Neighbourhood?> { get }
    var selectedCollectionSchedule: Observable<CollectionSchedule?> { get }
    var state: Observable<CalendarViewModel.State> { get }
    
    var areNotificationsActive: Bool { get }
    
    // Functions
    func select(neighbourhood: Neighbourhood)
    func bellTapped()
}

class CalendarViewModel: CalendarViewModelType {
    
    // MARK: Attributes
    
    private let collectionScheduleManager: CollectionScheduleManagerProtocol
    
    private let notificationsManager: NotificationsManagerProtocol
    
    private let disposeBag = DisposeBag()
    
    var areNotificationsActive: Bool {
        selectedNeighbourhoodRelay.value != nil &&
            InstallationManager.shared.notificationsEnabled.value &&
            (InstallationManager.shared.selectedNeighbourhood.value == selectedNeighbourhoodRelay.value)
    }
    
    // MARK: Relays
    
    private let selectedNeighbourhoodRelay = BehaviorRelay<Neighbourhood?>(value: Installation.current()?.neighbourhood)
    
    private let fullCollectionSchedule = BehaviorRelay<CollectionSchedule?>(value: nil)
    
    private let stateRelay = BehaviorRelay<State>(value: .idle)
    
    // MARK: Observables
    
    var selectedNeighbourhoodObservable: Observable<Neighbourhood?> {
        selectedNeighbourhoodRelay.asObservable()
    }
    
    var selectedCollectionSchedule: Observable<CollectionSchedule?> {
        fullCollectionSchedule.asObservable()
    }
    
    var state: Observable<State> {
        stateRelay.asObservable()
    }
    
    // MARK: Life cycle
    
    init(collectionScheduleManager: CollectionScheduleManagerProtocol,
         notificationsManager: NotificationsManagerProtocol) {
        self.collectionScheduleManager = collectionScheduleManager
        self.notificationsManager = notificationsManager
        
        bindCollectionScheduleToNeighbourhood()
        sharedManagerBinding()
    }
}

extension CalendarViewModel {
    
    enum State { case loading, idle }
    
}

// MARK: Public methods

extension CalendarViewModel {
    
    func select(neighbourhood: Neighbourhood) {
        selectedNeighbourhoodRelay.accept(neighbourhood)
    }
    
    func bellTapped() {
        if areNotificationsActive {
            InstallationManager.shared.notificationsEnabled.accept(false)
            notificationsManager.clearPendingNotifications()
        } else if let collectionSchedule = fullCollectionSchedule.value {
            notificationsManager.setupNotifications(for: collectionSchedule)
            InstallationManager.shared.updateNeighbourhood(to: selectedNeighbourhoodRelay.value)
        }
    }
    
}

// MARK: Private methods

private extension CalendarViewModel {
    
    func sharedManagerBinding() {
        InstallationManager
            .shared
            .selectedNeighbourhood
            .filter { $0 != self.selectedNeighbourhoodRelay.value && $0 != nil }
            .bind(to: selectedNeighbourhoodRelay)
            .disposed(by: disposeBag)
    }
    
    /// Make sure the collection schedule is up to date with the selected neighbourhood
    func bindCollectionScheduleToNeighbourhood() {
        selectedNeighbourhoodObservable
            .compactMap { $0 }
            .do(onNext: { [weak self] _ in
                self?.fullCollectionSchedule.accept(nil)
                self?.stateRelay.accept(.loading)
            })
            .flatMap { [unowned self] (neighbourhood) -> Single<CollectionSchedule> in
                self.collectionScheduleManager.collectionSchedule(for: neighbourhood)
            }
            .do(onNext: { [weak stateRelay] _ in stateRelay?.accept(.idle) })
            .bind(to: fullCollectionSchedule)
            .disposed(by: disposeBag)
    }
    
}
