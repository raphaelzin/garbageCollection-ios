//
//  NeighbourhoodSelectionViewModel.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-10-23.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol NeighbourhoodSelectionViewModelType: class {
    // Bindable attributes
    var neighbourhoods: Observable<[Neighbourhood]> { get }
    var state: Observable<NeighbourhoodSelectionViewModel.State> { get }
    
    func fetchNeighbourhoods(with term: String)
}

class NeighbourhoodSelectionViewModel: NeighbourhoodSelectionViewModelType {
    
    // Attributes
    
    private let disposeBag = DisposeBag()
    
    private let neighbourhoodsManager = NeighbourhoodsManager()
    
    // Relays
    
    private let neighbourhoodsRelay = BehaviorRelay<[Neighbourhood]>(value: [])
    
    private let stateRelay = BehaviorRelay<State>(value: .loading)
    
    // Observables
    
    var neighbourhoods: Observable<[Neighbourhood]> {
        return neighbourhoodsRelay.asObservable()
    }
    
    var state: Observable<State> {
        return stateRelay.asObservable()
    }
    
    // Lifecycle
    
    init() {
        fetchNeighbourhoods()
    }
    
}

extension NeighbourhoodSelectionViewModel {
    
    enum State { case loading, idle }
    
}

// MARK: Private methods

extension NeighbourhoodSelectionViewModel {
    
    func fetchNeighbourhoods(with term: String = "") {
        neighbourhoodsManager
            .fetchNeighbourhoods(with: term)
            .do(onSuccess: { [weak self] _ in self?.stateRelay.accept(.loading) })
            .subscribe(onSuccess: { [weak self] (neighbourhoods) in
                self?.stateRelay.accept(.idle)
                self?.neighbourhoodsRelay.accept(neighbourhoods)
            })
            .disposed(by: disposeBag)
    }
    
}
