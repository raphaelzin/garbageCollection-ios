//
//  FeedbackManager.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-12-15.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol FeedbackManagerProtocol: class {
    func sendFeedback(name: String?, email: String?, content: String) -> Completable
}

class FeedbackManager: FeedbackManagerProtocol {
    
    func sendFeedback(name: String?, email: String?, content: String) -> Completable {
        
        let feedback = Feedback()
        feedback.author = Installation.current()
        feedback.name = name
        feedback.email = email
        feedback.comment = content
        
        return feedback
            .rx
            .save()
            .asSingle()
            .asCompletable()
    }
    
}
