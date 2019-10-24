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
    var neighbourhoods: Observable<[Neighbourhood]> { get }
    
    func fetchNeighbourhoods(with term: String)
}

class NeighbourhoodSelectionViewModel: NeighbourhoodSelectionViewModelType {
    
    private let disposeBag = DisposeBag()
    
    private let neighbourhoodsRelay = BehaviorRelay<[Neighbourhood]>(value: [])
    
    private let neighbourhoodsManager = NeighbourhoodsManager()
    
    var neighbourhoods: Observable<[Neighbourhood]> {
        return neighbourhoodsRelay.asObservable()
    }
    
    init() {
        fetchNeighbourhoods()
    }
    
}

// MARK: Private methods

extension NeighbourhoodSelectionViewModel {
    
    func fetchNeighbourhoods(with term: String = "") {
        neighbourhoodsManager
            .fetchNeighbourhoods(with: term)
            .subscribe(onSuccess: { (neighbourhoods) in
                self.neighbourhoodsRelay.accept(neighbourhoods)
            })
            .disposed(by: disposeBag)
    }
    
}
