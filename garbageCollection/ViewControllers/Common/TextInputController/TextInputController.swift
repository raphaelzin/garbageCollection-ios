//
//  TextInputController.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-11-23.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import UIKit

protocol TextInputControllerCoordinatorDelegate: class {
    func didRequestDismiss(from controller: TextInputController)
}

protocol TextInputControllerDelegate: class {
    func didEnter(text: String)
}

class TextInputController: UIViewController {
    
    // MARK: Attributes
    
    weak var delegate: TextInputControllerDelegate?
    
    weak var coordinatorDelegate: TextInputControllerCoordinatorDelegate?
    
    private let placeholder: String
    
    // MARK: Subviews
    
    private lazy var textView: UITextView = {
        let tv = UITextView()
        tv.layer.cornerRadius = 10
        tv.backgroundColor = .white
        tv.font = .systemFont(ofSize: 16, weight: .regular)
        tv.textContainerInset = .init(top: 12, left: 12, bottom: 12, right: 12)
        tv.delegate = self
        tv.text = placeholder
        tv.textColor = .lightGray
        return tv
    }()
    
    // MARK: Lifecycle
    
    init(configurator: Configurator) {
        placeholder = configurator.placeholder
        
        super.init(nibName: nil, bundle: nil)
        
        navigationItem.title = configurator.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: configurator.actionButtonTitle, style: .done, target: self, action: #selector(onSaveTap))
        
        configureView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        dropTextViewShadow()
    }
}

// MARK: Private layout configuration

private extension TextInputController {
    
    func configureView() {
        view.backgroundColor = .veryLightGray
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onViewTap)))
    }
    
    func configureLayout() {
        view.addSubview(textView)
        textView.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalTo(view.safeAreaInsets).inset(16)
            make.height.equalTo(220)
        }
    }
    
    /// Drop shadow for container view
    func dropTextViewShadow() {
        let shadowPath = UIBezierPath(roundedRect: textView.frame, cornerRadius: 10).cgPath
        textView.layer.shadowPath = shadowPath
        textView.layer.shadowRadius = 4
        textView.layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
        textView.layer.shadowOffset = CGSize(width: -8, height: -3)
        textView.layer.shadowOpacity = 0.5
    }

}

// MARK: Private selectors

private extension TextInputController {
    
    @objc func onSaveTap() {
        coordinatorDelegate?.didRequestDismiss(from: self)
        delegate?.didEnter(text: textView.text)
    }
    
    @objc func onViewTap() {
        textView.resignFirstResponder()
    }
    
}

// MARK: Subtypes

extension TextInputController {
    
    struct Configurator {
        let title: String
        let placeholder: String
        let actionButtonTitle: String
    }
    
}

// MARK: TextView management

extension TextInputController: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholder
            textView.textColor = .lightGray
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholder && textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = .charcoalGrey
        }
    }
    
}
