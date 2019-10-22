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
    var selectedNeighbourhoodObservable: Observable<Neighbourhood?> { get }
}

class CalendarViewModel: CalendarViewModelType {
    
    private let selectedNeighbourhoodRelay = BehaviorRelay<Neighbourhood?>(value: nil)
    
    private let fullCollectionSchedule = BehaviorRelay<CollectionSchedule?>(value: nil)
    
    var selectedNeighbourhoodObservable: Observable<Neighbourhood?> {
        selectedNeighbourhoodRelay.asObservable()
    }

}

// MARK: Public methods

extension CalendarViewModel {
    
    func select(neighbourhood: Neighbourhood) {
        selectedNeighbourhoodRelay.accept(neighbourhood)
        
        
        
    }
    
}
