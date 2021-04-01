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
    
    func filter(with term: String)
}

class NeighbourhoodSelectionViewModel: NeighbourhoodSelectionViewModelType {
    
    // Attributes
    
    private var allNeighbourhoods: [Neighbourhood] = []
    
    private let disposeBag = DisposeBag()
    
    private let neighbourhoodsManager: NeighbourhoodsManagerProtocol
    
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
    
    init(neighbourhoodsManager: NeighbourhoodsManagerProtocol) {
        self.neighbourhoodsManager = neighbourhoodsManager
        
        fetchNeighbourhoods()
    }
    
}

extension NeighbourhoodSelectionViewModel {
    
    enum State { case loading, idle }
    
}

// MARK: Private methods

extension NeighbourhoodSelectionViewModel {
    
    func fetchNeighbourhoods() {
        neighbourhoodsManager
            .fetchNeighbourhoods()
            .do(onSuccess: { [weak self] _ in self?.stateRelay.accept(.loading) })
            .subscribe(onSuccess: { [weak self] (neighbourhoods) in
                self?.stateRelay.accept(.idle)
                self?.allNeighbourhoods = neighbourhoods
                self?.neighbourhoodsRelay.accept(neighbourhoods)
            })
            .disposed(by: disposeBag)
    }
    
    func filter(with term: String) {
        if term.isEmpty {
            neighbourhoodsRelay.accept(allNeighbourhoods)
            return
        }
        
        let filteredNeighbourhoods = allNeighbourhoods.filter { ($0.name ?? "").lowercased().contains(term.lowercased()) }
        neighbourhoodsRelay.accept(filteredNeighbourhoods)
    }
    
}
