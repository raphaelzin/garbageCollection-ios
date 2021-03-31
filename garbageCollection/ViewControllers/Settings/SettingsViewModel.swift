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
    var selectedNeighbourhood: BehaviorRelay<Neighbourhood?> { get }
    var hintsNotifications: BehaviorRelay<Bool> { get }
}

class SettingsViewModel: SettingsViewModelType {
    
    // MARK: Attributes
    
    var selectedNeighbourhood: BehaviorRelay<Neighbourhood?> {
        InstallationManager.shared.selectedNeighbourhood
    }
    
    var hintsNotifications: BehaviorRelay<Bool> {
        InstallationManager.shared.hintsEnabled
    }
}
