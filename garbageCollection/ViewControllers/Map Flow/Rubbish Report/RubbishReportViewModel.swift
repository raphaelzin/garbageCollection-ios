//
//  RubbishReportViewModel.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-11-23.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol RubbishReportViewModelType: class {
    var whenRelay: BehaviorRelay<Date?> { get }
    var detailsRelay: BehaviorRelay<String?> { get }
    var pictureRelay: BehaviorRelay<UIImage?> { get }
    var locationRelay: BehaviorRelay<Location?> { get }
    
    var isValidInput: Driver<Bool> { get }
    
    func driver(for fieldType: RubbishReportController.FieldType) -> Driver<String?>
}

class RubbishReportViewModel: RubbishReportViewModelType {
    
    // Relays
    
    let whenRelay: BehaviorRelay<Date?> = .init(value: Date())
    
    let detailsRelay: BehaviorRelay<String?> = .init(value: nil)
    
    let pictureRelay: BehaviorRelay<UIImage?> = .init(value: nil)
    
    let locationRelay: BehaviorRelay<Location?> = .init(value: nil)
        
    var isValidInput: Driver<Bool> {
        Driver
            .combineLatest(locationRelay.asDriver(), whenRelay.asDriver(), pictureRelay.asDriver())
            .map { location, when, picture -> Bool in
                ([picture, location, when] as [Any?]).allSatisfy { $0 != nil }
        }
    }
    
}

// MARK: Helper methods

extension RubbishReportViewModel {
    
    func driver(for fieldType: RubbishReportController.FieldType) -> Driver<String?> {
        switch fieldType {
        case .details: return detailsRelay.asDriver()
        case .when: return whenRelay.asDriver().map { $0?.formatted(as: .hourAndDate) }
        case .where: return locationRelay.asDriver().map { $0?.address }
        }
    }
    
}
 
