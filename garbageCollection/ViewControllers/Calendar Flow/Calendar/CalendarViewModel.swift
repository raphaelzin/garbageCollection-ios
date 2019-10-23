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
    
    // Functions
    func select(neighbourhood: Neighbourhood)
}

class CalendarViewModel: CalendarViewModelType {
    
    private lazy var collectionPointsManager = CollectionPointsManager()
    
    private let disposeBag = DisposeBag()
    
    // Relays
    
    private let selectedNeighbourhoodRelay = BehaviorRelay<Neighbourhood?>(value: nil)
    
    private let fullCollectionSchedule = BehaviorRelay<CollectionSchedule?>(value: nil)
    
    private var stateRelay = BehaviorRelay<State>(value: .idle)
    
    // Observables
    
    var selectedNeighbourhoodObservable: Observable<Neighbourhood?> {
        selectedNeighbourhoodRelay.asObservable()
    }
    
    var selectedCollectionSchedule: Observable<CollectionSchedule?> {
        fullCollectionSchedule.asObservable()
    }
    
    var state: Observable<State> {
        return stateRelay.asObservable()
    }
    
    init() {
        bindCollectionScheduleToNeighbourhood()
        
        Neighbourhood
            .query()?
            .rx
            .getFirstObject()
            .delay(.seconds(2), scheduler: MainScheduler.instance)
            .do { self.stateRelay.accept(.loading) }
            .delay(.seconds(4), scheduler: MainScheduler.instance)
            .asSingle()
            .map { $0 as! Neighbourhood }
            .do { self.stateRelay.accept(.idle) }
            .subscribe(onSuccess: { self.select(neighbourhood: $0) })
            .disposed(by: disposeBag)
            
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
    
    func userTappedBell() {
        
    }
    
}

// MARK: Private methods

private extension CalendarViewModel {
    
    /// Make sure the collection schedule is up to date with the selected neighbourhood
    func bindCollectionScheduleToNeighbourhood() {
        selectedNeighbourhoodObservable.compactMap { $0 }.flatMap { (neighbourhood) -> Single<CollectionSchedule> in
            return self.collectionPointsManager.collectionSchedule(for: neighbourhood)
            }
        .bind(to: fullCollectionSchedule)
        .disposed(by: disposeBag)
    }
    
}
