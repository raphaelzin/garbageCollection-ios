//
//  UICollectionView.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-11-16.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import UIKit

extension UICollectionView {
    /// Registers cell
    func registerCell<T: UICollectionViewCell>(cellClass: T.Type) {
        self.register(T.self, forCellWithReuseIdentifier: T.defaultIdentifier)
    }
    
    /// Dequeue cell
    func dequeue<T: UICollectionViewCell>(cellClass: T.Type, indexPath: IndexPath) -> T {
        return self.dequeue(withIdentifier: cellClass.defaultIdentifier, indexPath: indexPath)
    }
    
    /// Dequeue cell with force cast
    private func dequeue<T: UICollectionViewCell>(withIdentifier id: String, indexPath: IndexPath) -> T {
        // swiftlint:disable:next force_cast
        return self.dequeueReusableCell(withReuseIdentifier: id, for: indexPath) as! T
    }
}
