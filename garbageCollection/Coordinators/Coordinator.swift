//
//  Coordinator.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-10-19.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import Foundation

/// The Coordinator protocol
public protocol Coordinator: class {
    var childCoordinators: [Coordinator] { get set }
}

public extension Coordinator {
    /// Add child coordinator
    func addChildCoordinator(_ childCoordinator: Coordinator) {
        self.childCoordinators.append(childCoordinator)
    }
    
    /// Remove specific child coordinator
    func removeChildCoordinator(_ childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0 !== childCoordinator }
    }
}
