//
//  InstallationManager.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-12-21.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class InstallationManager {
    
    // Singleton instance
    
    static let shared = InstallationManager()
    
    // private attributes
    
    private let disposeBag = DisposeBag()
    
    // Relay attributes
    
    let selectedNeighbourhood = BehaviorRelay<Neighbourhood?>(value: Installation.current()?.neighbourhood)
    
    let notificationsEnabled = BehaviorRelay<Bool>(value: Installation.current()?.notificationsEnabled ?? false)
    
    let hintsEnabled = BehaviorRelay<Bool>(value: Installation.current()?.hintsEnabled ?? false)
    
    // Lifecycle
    
    private init() {
        observeAndSaveChanges()
    }
    
}

// MARK: Access methods

extension InstallationManager {
    
    func updateNeighbourhood(to neighbourhood: Neighbourhood?) {
        Installation.current()?.neighbourhood = neighbourhood
        Installation.current()?.notificationsEnabled = neighbourhood != nil
        selectedNeighbourhood.accept(neighbourhood)
        notificationsEnabled.accept(neighbourhood != nil)
    }
    
    func registerForNotifications(with token: String) {
        guard let installation = Installation.current() else { return }
        installation.deviceToken = token
        installation.saveInBackground()
    }

}

// MARK: Private methods

private extension InstallationManager {
    
    func observeAndSaveChanges() {
        Observable
            .combineLatest(notificationsEnabled.asObservable(),
                           hintsEnabled.asObservable(),
                           selectedNeighbourhood)
            .skip(1)
            .throttle(.seconds(4), scheduler: MainScheduler.asyncInstance)
            .flatMapLatest({ reminders, hints, neighbourhood -> Single<Bool> in
                guard let installation = Installation.current() else {
                    throw GCError.Misc.invalidUser
                }
                
                installation.neighbourhood = neighbourhood
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
