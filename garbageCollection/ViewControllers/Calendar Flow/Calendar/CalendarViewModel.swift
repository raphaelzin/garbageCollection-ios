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
    var notificationsActiveRelay: BehaviorRelay<Bool> { get }
    var state: Observable<CalendarViewModel.State> { get }
    
    var areNotificationsActive: Bool { get }
    
    var notificationActive: Observable<Bool> { get }
    
    // Functions
    func select(neighbourhood: Neighbourhood)
    func bellTapped()
}

class CalendarViewModel: CalendarViewModelType {
    
    private lazy var collectionPointsManager = CollectionScheduleManager()
    
    private lazy var notificationsManager = NotificationsManager()
    
    private let disposeBag = DisposeBag()
    
    var areNotificationsActive: Bool {
        return notificationsActiveRelay.value
    }
    
    // Relays
    
    private let selectedNeighbourhoodRelay = BehaviorRelay<Neighbourhood?>(value: Installation.current()?.neighbourhood)
    
    private let fullCollectionSchedule = BehaviorRelay<CollectionSchedule?>(value: nil)
    
    private let stateRelay = BehaviorRelay<State>(value: .idle)
    
    let notificationsActiveRelay = BehaviorRelay<Bool>(value: false)
    
    // Observables
    
    var selectedNeighbourhoodObservable: Observable<Neighbourhood?> {
        selectedNeighbourhoodRelay.asObservable()
    }
    
    var selectedCollectionSchedule: Observable<CollectionSchedule?> {
        fullCollectionSchedule.asObservable()
    }
    
    var state: Observable<State> {
        stateRelay.asObservable()
    }
    
    var notificationActive: Observable<Bool> {
        notificationsActiveRelay.asObservable()
    }
    
    init() {
        bindCollectionScheduleToNeighbourhood()
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
        if notificationsActiveRelay.value {
            Installation.current()?.notificationsEnabled = false
        } else if let collectionSchedule = fullCollectionSchedule.value {
            notificationsManager.setupNotifications(for: collectionSchedule)
            Installation.current()?.neighbourhood = selectedNeighbourhoodRelay.value
            Installation.current()?.notificationsEnabled = true
        }
        
        Installation.current()?.saveEventually()
        notificationsActiveRelay.accept(!notificationsActiveRelay.value)
    }
    
}

// MARK: Private methods

private extension CalendarViewModel {
    
    /// Make sure the collection schedule is up to date with the selected neighbourhood
    func bindCollectionScheduleToNeighbourhood() {
        selectedNeighbourhoodObservable
            .compactMap { $0 }
            .do(onNext: { [weak self] neighbourhood in
                self?.fullCollectionSchedule.accept(nil)
                self?.stateRelay.accept(.loading)
                
                if let installation = Installation.current() {
                    let notificationsEnabled = (installation.neighbourhood == .some(neighbourhood)) && installation.notificationsEnabled
                    self?.notificationsActiveRelay.accept(notificationsEnabled)
                }
            })
            .flatMap { [unowned self] (neighbourhood) -> Single<CollectionSchedule> in
                self.collectionPointsManager.collectionSchedule(for: neighbourhood)
            }
            .do(onNext: { [weak stateRelay] _ in stateRelay?.accept(.idle) })
            .bind(to: fullCollectionSchedule)
            .disposed(by: disposeBag)
    }
    
}
