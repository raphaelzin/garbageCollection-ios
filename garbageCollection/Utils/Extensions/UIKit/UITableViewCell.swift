//
//  UITableViewCell.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-10-21.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension UITableViewCell {
    static var defaultIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell {
    
    func configure(with configurator: UITableViewCellConfigurator) {
        textLabel?.text = configurator.title
        accessoryType = configurator.accessory
    }
    
    func bindContent(with driver: Driver<String?>, placeholder: String, disposeBag: DisposeBag) {
        driver
            .do(onNext: { (value) in
                self.textLabel?.textColor = value == nil ? .lightGray : .label
            })
            .map { $0 ?? placeholder }
            .drive(textLabel!.rx.text)
            .disposed(by: disposeBag)
    }
    
}
