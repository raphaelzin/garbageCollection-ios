//
//  NextCollectionDatesController.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2020-07-03.
//  Copyright © 2020 Raphael Inc. All rights reserved.
//

import UIKit

class NextCollectionDatesController: UIViewController {
    
    // MARK: Attributes
    
    var nextDate: Date!
    
    // MARK: Subviews
    
    private lazy var containerView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.clipsToBounds = true
        v.layer.cornerRadius = 12
        return v
    }()
    
    private lazy var headerLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.text = "Coletas de sexta feira"
        lbl.textAlignment = .center
        return lbl
    }()
    
    private lazy var headerView: UIView = {
        let v = UIView()
        v.backgroundColor = .defaultBlue
        return v
    }()
    
    private lazy var bottomView: UIView = {
        let v = UIView()
        v.backgroundColor = .defaultBlue
        return v
    }()
    
    private lazy var datesStack: UIStackView = {
        let stv = UIStackView()
        return stv
    }()
    
    private lazy var extraInfo: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.text = "Entre 20:00 e 22:00"
        return lbl
    }()
    
    private lazy var dismissButton: UIButton = {
        var btn = UIButton(type: .system)
        btn.setTitle("Fechar", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(onDismissTap), for: .touchUpInside)
        return btn
    }()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureLayout()
    }
    
}

// MARK: Private selector

private extension NextCollectionDatesController {
    
    @objc func onDismissTap() {
        dismiss(animated: true)
    }
    
}


// MARK: View configuration

private extension NextCollectionDatesController {
    
    func configureView() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
    }
    
    func configureLayout() {
        view.addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 50))
            make.center.equalToSuperview()
            make.height.equalTo(180)
        }
        
        // Configure header
        containerView.addSubview(headerView)
        headerView.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(34)
        }
        
        headerView.addSubview(headerLabel)
        headerLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        // Config footer
        containerView.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(34)
        }
        
        bottomView.addSubview(dismissButton)
        dismissButton.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
    
}

extension NextCollectionDatesController: CardFlipDestinationAnimatable {
    func destinationView() -> UIView {
        containerView
    }
    
    func destinationFrame() -> CGRect {
        containerView.frame
    }
    
}

extension NextCollectionDatesController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        CardFlipTransition(isForward: true)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        CardFlipTransition(isForward: false)
    }
}
