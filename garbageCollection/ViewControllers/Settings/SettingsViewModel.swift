//
//  SettingsViewModel.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-12-08.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol SettingsViewModelType: class {
    var reminderNotifications: BehaviorRelay<Bool> { get }
    var hintsNotifications: BehaviorRelay<Bool> { get }
}

class SettingsViewModel: SettingsViewModelType {
    
    // MARK: Attributes
    
    let reminderNotifications: BehaviorRelay<Bool>
    
    let hintsNotifications: BehaviorRelay<Bool>
    
    private let disposeBag = DisposeBag()
    
    // MARK: Lifecycle
    
    init() {
        let installation = Installation.current()
        reminderNotifications = BehaviorRelay(value: installation?.notificationsEnabled ?? false)
        hintsNotifications = BehaviorRelay(value: installation?.hintsEnabled ?? false)
        
        updateUserPreferences()
    }
    
}

private extension SettingsViewModel {
    
    func updateUserPreferences() {
        Observable
            .combineLatest(reminderNotifications.asObservable(), hintsNotifications.asObservable())
            .throttle(.seconds(4), scheduler: MainScheduler.asyncInstance)
            .flatMapLatest({ reminders, hints -> Single<Bool> in
                guard let installation = Installation.current() else {
                    throw GCError.Misc.invalidUser
                }
                
                installation.notificationsEnabled = reminders
                installation.hintsEnabled = hints
                return installation.rx.save().asSingle()
            })
            .subscribe(onNext: { success in
                print("Saved successfully: \(success)")
            }, onError: { error in
                print(error.localizedDescription)
            }).disposed(by: disposeBag)
    }
    
}
