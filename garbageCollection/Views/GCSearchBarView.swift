//
//  GCSearchBarView.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-11-30.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class GCSearchBarView: UITextField {
    
    private let disposeBag = DisposeBag()
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
        observeState()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: private

private extension GCSearchBarView {
    
    func configureView() {
        layer.cornerRadius = 22
        autocapitalizationType = .sentences
        autocorrectionType = .no
        leftViewMode = .always
        backgroundColor = .safeSystemBackground
        returnKeyType = .done
        
        let imv = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        imv.contentMode = .center
        imv.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 44, height: 44))
        }
        leftView = imv
    }
    
    func observeState() {
        rx.controlEvent([.editingDidBegin, .editingDidEnd])
            .asObservable()
            .subscribe(onNext: { _ in
                self.updateBorderState(toHidden: !self.isEditing)
            })
            .disposed(by: disposeBag)
    }
    
    func updateBorderState(toHidden hidden: Bool) {
        let borderWidth = CABasicAnimation(keyPath: "borderWidth")
        
        let fromValue: CGFloat = layer.borderWidth
        let toValue: CGFloat = hidden ? 0 : 2
        
        borderWidth.fromValue = fromValue
        borderWidth.toValue = toValue
        borderWidth.duration = 0.2
        
        layer.borderWidth = fromValue
        layer.borderColor = UIColor.defaultBlue.cgColor
        layer.add(borderWidth, forKey: "Width")
        layer.borderWidth = toValue
    }
    
}
