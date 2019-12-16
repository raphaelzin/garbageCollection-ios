//
//  FeedbackViewModel.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-12-15.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol FeedbackViewModelType: class {
    var validInput: Observable<Bool> { get }
    var nameRelay: BehaviorRelay<String?> { get }
    var emailRelay: BehaviorRelay<String?> { get }
    var feedbackContentRelay: BehaviorRelay<String?> { get }
    
    func sendFeedback() -> Completable
}

class FeedbackViewModel: FeedbackViewModelType {
    
    // MARK: Relays
    
    let nameRelay: BehaviorRelay<String?>
    
    let emailRelay: BehaviorRelay<String?>
    
    let feedbackContentRelay: BehaviorRelay<String?>
    
    var validInput: Observable<Bool> {
        feedbackContentRelay
            .asObservable()
            .map { !($0 ?? "" ).isEmpty }
    }
    
    // MARK: Lifecycle
    
    init() {
        nameRelay = BehaviorRelay<String?>(value: nil)
        emailRelay = BehaviorRelay<String?>(value: nil)
        feedbackContentRelay = BehaviorRelay<String?>(value: nil)
    }
    
}

extension FeedbackViewModel {
    
    func sendFeedback() -> Completable {
        return .empty()
    }
    
}
