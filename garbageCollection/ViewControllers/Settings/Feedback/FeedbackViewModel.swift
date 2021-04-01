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
    var contentRelay: BehaviorRelay<String?> { get }
    
    func sendFeedback() -> Completable
}

class FeedbackViewModel: FeedbackViewModelType {
    
    // MARK: Relays
    
    let nameRelay: BehaviorRelay<String?>
    
    let emailRelay: BehaviorRelay<String?>
    
    let contentRelay: BehaviorRelay<String?>
    
    private let feedbackManager: FeedbackManagerProtocol
    
    var validInput: Observable<Bool> {
        contentRelay
            .asObservable()
            .map { !($0 ?? "" ).isEmpty }
    }
    
    // MARK: Lifecycle
    
    init(feedbackManager: FeedbackManagerProtocol) {
        self.feedbackManager = feedbackManager
        
        nameRelay = BehaviorRelay<String?>(value: nil)
        emailRelay = BehaviorRelay<String?>(value: nil)
        contentRelay = BehaviorRelay<String?>(value: nil)
    }
    
}

extension FeedbackViewModel {
    
    func sendFeedback() -> Completable {
        guard let content = contentRelay.value, !content.isEmpty else {
            return .error(GCError.UserInteraction.invalidFeedbackInput)
        }
        
        return feedbackManager.sendFeedback(name: nameRelay.value,
                                            email: emailRelay.value,
                                            content: content)
    }
    
}
