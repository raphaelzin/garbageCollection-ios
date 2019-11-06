//
//  GCExpandableButton.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-10-27.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol GCExpandableButtonDelegate: class {
    func didTap(button: GCExpandableButton)
}

class GCExpandableButton: UIControl {
    
    // Internal Attributes
    
    weak var delegate: GCExpandableButtonDelegate?
    
    var contentBackgroundColor: UIColor {
        get { contentBackground.backgroundColor ?? .white }
        set { contentBackground.backgroundColor = newValue }
    }
    
    var contentTextColor: UIColor {
        get { contentLabel.textColor }
        set { contentLabel.textColor = newValue }
    }
    
    var buttonBackgroundColor: UIColor {
        get { button.backgroundColor ?? .white }
        set { button.backgroundColor = newValue }
    }
    
    var buttonIcon: UIImage? {
        get { button.currentImage }
        set { button.setImage(newValue, for: .normal) }
    }
    
    // Private Attributes
    
    private let stateRelay = BehaviorRelay<ExpandableState>(value: .collapsed)
    
    private let disposeBag = DisposeBag()
    
    private let cornerRadius: CGFloat = 8
    
    private let collapsedSize: CGSize = .init(width: 36, height: 36)
    
    // Subviews
    
    private lazy var button: UIButton = {
        let btn = UIButton()
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowRadius = 4
        btn.layer.shadowOpacity = 0.3
        btn.layer.shadowOffset = .zero
        
        btn.backgroundColor = .white
        btn.layer.cornerRadius = cornerRadius
        btn.addTarget(self, action: #selector(onButtonTap), for: .touchUpInside)
        
        return btn
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.text = "Reportar entulho"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onButtonTap)))
        return label
    }()
    
    private lazy var contentBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = cornerRadius
        return view
    }()
    
    // Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureLayout()
        bindState()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupShadow()
    }
    
}

// MARK: Public methods

extension GCExpandableButton {
    
    func setContent(_ content: String) {
        if content.isEmpty {
            stateRelay.accept(.collapsed)
            return
        }
        
        stateRelay.accept(.expanded)
        
        contentLabel.text = content
        
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 5,
                       options: .curveLinear,
                       animations: {
            self.layoutIfNeeded()
        })
        
    }
    
    func setState(_ state: ExpandableState, afterInterval: TimeInterval = 0) {
        Observable
            .of(state)
            .delay(.seconds(Int(afterInterval)), scheduler: MainScheduler.instance)
            .asSingle()
            .asDriver(onErrorJustReturn: .collapsed)
            .drive(stateRelay)
            .disposed(by: disposeBag)
    }
    
}

extension GCExpandableButton {
    
    enum ExpandableState { case expanded, collapsed }
    
    typealias Style = (contentColor: UIColor, backgroundColor: UIColor, icon: UIImage)
    
}

// MARK: Private layout methods

private extension GCExpandableButton {
    
    func configureLayout() {
        
        addSubview(contentBackground)
        contentBackground.addSubview(contentLabel)
        contentBackground.addSubview(button)
        
        contentBackground.snp.makeConstraints { (make) in
            make.height.equalTo(collapsedSize.height)
            make.width.greaterThanOrEqualTo(collapsedSize.width)
            make.top.trailing.bottom.equalTo(self)
        }
        
        button.snp.makeConstraints { (make) in
            make.size.equalTo(collapsedSize)
            make.trailing.top.bottom.equalTo(contentBackground)
        }
        
        contentLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(contentBackground).offset(-(self.collapsedSize.width + 8))
            make.leading.equalTo(contentBackground).offset(8)
            make.centerY.equalTo(contentBackground)
        }
    }
    
    func setupShadow() {
        layer.shadowRadius = 4
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.3
    }
    
}

// MARK: Private methods

private extension GCExpandableButton {
    
    func bindState() {
        
        stateRelay.subscribe(onNext: { (state) in
            
            if state == .collapsed {
                self.contentBackground.snp.remakeConstraints { (make) in
                    make.size.equalTo(self.collapsedSize)
                    make.top.trailing.bottom.equalTo(self)
                }
            } else {
                self.contentBackground.snp.remakeConstraints { (make) in
                    make.width.greaterThanOrEqualTo(self.collapsedSize.width)
                    make.height.equalTo(self.collapsedSize.height)
                    make.top.trailing.bottom.equalTo(self)
                }
            }
            
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           usingSpringWithDamping: 0.7,
                           initialSpringVelocity: 5,
                           options: .curveLinear,
                           animations: {
                self.layoutIfNeeded()
            })
            
            }).disposed(by: disposeBag)
        
    }
}

// MARK: Private selectors

private extension GCExpandableButton {
    
    @objc func onButtonTap() {
        delegate?.didTap(button: self)
    }
    
}
