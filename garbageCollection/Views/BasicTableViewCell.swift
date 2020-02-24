//
//  BasicTableViewCell.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-11-25.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class BasicTableViewCell: UITableViewCell {
    
    lazy var basicLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        return l
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: Public configuration methods

extension BasicTableViewCell {
    
    func configure(with configurator: UITableViewCellConfigurator) {
        basicLabel.text = configurator.title
        accessoryType = configurator.accessory
    }
    
    func bindContent(with driver: Driver<String?>, placeholder: String, disposeBag: DisposeBag) {
        driver
            .do(onNext: { (value) in
                self.basicLabel.textColor = value == nil ? .lightGray : .safeLabel
            })
            .map { $0 ?? placeholder }
            .drive(basicLabel.rx.text)
            .disposed(by: disposeBag)
    }
   
}

// MARK: Private layout methods

private extension BasicTableViewCell {
    
    func configureLayout() {
        addSubview(basicLabel)
        basicLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(self).inset(UIEdgeInsets(top: 6, left: 16, bottom: 6, right: 32))
            make.height.greaterThanOrEqualTo(44)
        }
    }
    
}
