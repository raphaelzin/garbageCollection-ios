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
    
    static let shared = InstallationManager()
    
    private let neighbourhoodRelay = BehaviorRelay<Neighbourhood?>(value: Installation.current()?.neighbourhood)
    
    var selectedNeighbourhood: Observable<Neighbourhood?> {
        neighbourhoodRelay.asObservable()
    }
    
    private init() {}
    
}

// MARK: Access methods

extension InstallationManager {
    
    func updateNeighbourhood(to neighbourhood: Neighbourhood?) {
        Installation.current()?.neighbourhood = neighbourhood
        Installation.current()?.notificationsEnabled = neighbourhood != nil
        neighbourhoodRelay.accept(neighbourhood)
    }
    
    func registerForNotifications(with token: String) {
        guard let installation = Installation.current() else { return }
        installation.deviceToken = token
        installation.saveInBackground()
    }

}
