//
//  UserNotification+Rx.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-10-27.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import Foundation
import UserNotifications
import RxSwift

extension Reactive where Base: UNUserNotificationCenter {
    
    func requestAuthorization(options: UNAuthorizationOptions) -> Single<Bool> {
        
        return Single.create { (single) -> Disposable in
            self.base.requestAuthorization(options: options) { (granted, error) in
                if let error = error {
                    single(.error(error))
                }
                
                single(.success(granted))
            }
            
            return Disposables.create()
        }
        
    }
    
    func getAuthorizationStatus() -> Single<UNAuthorizationStatus> {
        Single.create { (single) -> Disposable in
            self.base.getNotificationSettings { (settings) in
                single(.success(settings.authorizationStatus))
            }
            
            return Disposables.create()
        }
        
    }
    
}
