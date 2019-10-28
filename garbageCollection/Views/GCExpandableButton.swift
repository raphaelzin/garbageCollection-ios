//
//  GCExpandableButton.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-10-27.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import UIKit
import RxSwift

class GCExpandableButton: UIControl {
    
    private let subject = BehaviorSubject<ExpandableState>(value: .collapsed)
    
    let disposeBag = DisposeBag()
    
    private lazy var button: UIButton = {
        let btn = UIButton()
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowRadius = 4
        btn.layer.cornerRadius = 8
        return btn
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowRadius = 4
        return label
    }()
    
    private lazy var contentBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        return view
    }()
    
}

// MARK: Public methods

extension GCExpandableButton {
    
//    func
    
}

extension GCExpandableButton {
    
    enum ExpandableState { case expanded, collapsed }
    
}

// MARK: Private layout methods

private extension GCExpandableButton {
    
    func configureLayout() {
        addSubview(contentBackground)
        contentBackground.snp.makeConstraints { (make) in
            make.height.equalTo(36)
            make.edges.equalTo(self)
        }
        
        contentBackground.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 36, height: 36))
            make.trailing.top.bottom.equalTo(contentBackground)
        }
        
        contentBackground.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(contentBackground).offset(-44)
        }
    }
    
}

// MARK: Private methods

private extension GCExpandableButton {
    
    func bindState() {
        
        subject.subscribe(onNext: { (state) in
                
            if state == .collapsed {
                
            } else {
                
            }
            
            }).disposed(by: disposeBag)
        
    }
    
}
