//
//  FeedbackController.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-12-14.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import UIKit

protocol FeedbackControllerCoordinatorDelegate: class {
    func didRequestDismiss()
}

class FeedbackController: GCViewModelController<FeedbackViewModelType> {
    
    // MARK: Attributes
    
    private let placeholder: String = "Conta pra gente sobre sua experiencia com o app ;)"
    
    // MARK: Subviews
    
    private lazy var scrollView = UIScrollView()
    
    private lazy var nameLabel: UILabel = {
        getTitleLabel(withTitle: "Seu nome (opcional)")
    }()
    
    private lazy var emailLabel: UILabel = {
        getTitleLabel(withTitle: "Seu email (opcional)")
    }()
    
    private lazy var feedbackLabel: UILabel = {
        getTitleLabel(withTitle: "Seu comentário/suggestão")
    }()
    
    private lazy var nameTextField: GCPaddingTextField = {
        let tf = GCPaddingTextField()
        tf.layer.cornerRadius = 10
        tf.backgroundColor = .white
        tf.placeholder = "Raphael Souza"
        return tf
    }()
    
    private lazy var emailTextField: GCPaddingTextField = {
        let tf = GCPaddingTextField()
        tf.layer.cornerRadius = 10
        tf.backgroundColor = .white
        tf.placeholder = "seu@email.com"
        return tf
    }()
    
    lazy var textView: UITextView = {
        let tv = UITextView()
        tv.layer.cornerRadius = 10
        tv.backgroundColor = .secondarySystemGroupedBackground
        tv.font = .systemFont(ofSize: 16, weight: .regular)
        tv.textContainerInset = .init(top: 12, left: 12, bottom: 12, right: 12)
        tv.delegate = self
        tv.text = placeholder
        tv.textColor = .lightGray
        return tv
    }()
    
    // MARK: Lifecycle
    
    override init(viewModel: FeedbackViewModelType) {
        super.init(viewModel: viewModel)
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        addDefaultShadow(to: nameTextField)
        addDefaultShadow(to: emailTextField)
        addDefaultShadow(to: textView)
    }
    
}

private extension FeedbackController {
    
    func configureView() {
        view.backgroundColor = .systemGroupedBackground
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onViewTap)))
    }
    
    func configureLayout() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        scrollView.contentLayoutGuide.snp.makeConstraints { (make) in
            make.width.equalTo(scrollView)
        }
        
        scrollView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalTo(scrollView.contentLayoutGuide).inset(UIEdgeInsets(top: 16, left: 22, bottom: 0, right: 16))
        }
        
        scrollView.addSubview(nameTextField)
        nameTextField.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(scrollView.contentLayoutGuide).inset(16)
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.height.equalTo(50)
        }

        scrollView.addSubview(emailLabel)
        emailLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(scrollView.contentLayoutGuide).inset(UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 16))
            make.top.equalTo(nameTextField.snp.bottom).offset(26)
        }
        
        scrollView.addSubview(emailTextField)
        emailTextField.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(scrollView.contentLayoutGuide).inset(16)
            make.top.equalTo(emailLabel.snp.bottom).offset(8)
            make.height.equalTo(50)
        }
        
        scrollView.addSubview(feedbackLabel)
        feedbackLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(scrollView.contentLayoutGuide).inset(UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 16))
            make.top.equalTo(emailTextField.snp.bottom).offset(26)
        }
        
        scrollView.addSubview(textView)
        textView.snp.makeConstraints { (make) in
            make.top.equalTo(feedbackLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(scrollView.contentLayoutGuide).inset(16)
            make.height.equalTo(220)
        }
        
    }
    
}

// MARK: Private methods

private extension FeedbackController {
    
    func addDefaultShadow(to view: UIView) {
        view.layer.shadowRadius = 4
        view.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowOpacity = 0.2

    }
    
    func getTitleLabel(withTitle title: String) -> UILabel {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 16, weight: .semibold)
        lbl.text = title
        return lbl
    }
    
}

// MARK: Private selectors

private extension FeedbackController {
    
    @objc func onSaveTap() {
//        delegate?.didEnter(text: textView.text)
//        coordinatorDelegate?.didRequestDismiss(from: self)
    }
    
    @objc func onViewTap() {
        
    }
    
}

// MARK: TextView management

extension FeedbackController: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholder
            textView.textColor = .lightGray
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholder && textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = .label
        }
    }
    
}
