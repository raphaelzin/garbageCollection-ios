//
//  FeedbackController.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-12-14.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NotificationBannerSwift

protocol FeedbackControllerCoordinatorDelegate: class {
    func didRequestDismiss(from controller: FeedbackController)
}

class FeedbackController: GCViewModelController<FeedbackViewModelType> {
    
    // MARK: Attributes
    
    weak var coordinatorDelegate: FeedbackControllerCoordinatorDelegate?
    
    private let placeholder: String = "Conta pra gente sobre sua experiencia com o app ;)"
    
    private let disposeBag = DisposeBag()
    
    // MARK: Subviews
    
    private lazy var scrollView = UIScrollView()
    
    private lazy var nameLabel: UILabel = {
        getTitleLabel(withTitle: "Seu nome (opcional)")
    }()
    
    private lazy var emailLabel: UILabel = {
        getTitleLabel(withTitle: "Seu email (opcional)")
    }()
    
    private lazy var feedbackLabel: UILabel = {
        getTitleLabel(withTitle: "Seu comentário/sugestão")
    }()
    
    private lazy var nameTextField: GCPaddingTextField = {
        let tf = GCPaddingTextField()
        tf.layer.cornerRadius = 10
        tf.returnKeyType = .next
        tf.backgroundColor = .secondarySystemGroupedBackground
        tf.placeholder = "Raphael Souza"
        tf.delegate = self
        tf.rx.text
            .asDriver(onErrorJustReturn: nil)
            .drive(viewModel.nameRelay)
            .disposed(by: disposeBag)
        return tf
    }()
    
    private lazy var emailTextField: GCPaddingTextField = {
        let tf = GCPaddingTextField()
        tf.layer.cornerRadius = 10
        tf.returnKeyType = .next
        tf.backgroundColor = .secondarySystemGroupedBackground
        tf.placeholder = "seu@email.com"
        tf.delegate = self
        
        tf.rx.text
            .asDriver(onErrorJustReturn: nil)
            .drive(viewModel.emailRelay)
            .disposed(by: disposeBag)
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
        tv.textColor = .placeholderText
        tv.rx.text
            .filter { $0 != self.placeholder }
            .asDriver(onErrorJustReturn: nil)
            .drive(viewModel.contentRelay)
            .disposed(by: disposeBag)
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
        addKeyboardListeners()
        navigationItem.title = "Contato"
        view.backgroundColor = .systemGroupedBackground
        
        let sendBtn = UIBarButtonItem(title: "Enviar", style: .done, target: self, action: #selector(onSendTap))
        navigationItem.rightBarButtonItem = sendBtn
        
        viewModel
            .validInput
            .asDriver(onErrorJustReturn: false)
            .drive(sendBtn.rx.isEnabled)
            .disposed(by: disposeBag)
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
            make.leading.trailing.top.equalTo(scrollView.contentLayoutGuide).inset(UIEdgeInsets(top: 24, left: 22, bottom: 0, right: 16))
        }
        
        scrollView.addSubview(nameTextField)
        nameTextField.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(scrollView.contentLayoutGuide).inset(16)
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.height.equalTo(44)
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
            make.height.equalTo(44)
        }
        
        scrollView.addSubview(feedbackLabel)
        feedbackLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(scrollView.contentLayoutGuide).inset(UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 16))
            make.top.equalTo(emailTextField.snp.bottom).offset(26)
        }
        
        scrollView.addSubview(textView)
        textView.snp.makeConstraints { (make) in
            make.top.equalTo(feedbackLabel.snp.bottom).offset(8)
            make.bottom.equalTo(scrollView.contentLayoutGuide).offset(-16)
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
    
    @objc func onSendTap() {
        viewModel
            .sendFeedback()
            .subscribe(onCompleted: {
                let banner = NotificationBanner(title: "Tudo certo!", subtitle: "Mensagem enviada com sucesso!", style: .success)
                banner.show()
                self.coordinatorDelegate?.didRequestDismiss(from: self)
            }, onError: { error in
                self.alert(error: error)
            })
            .disposed(by: disposeBag)
    }
    
}

// MARK: TextView/TextField management

extension FeedbackController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            emailTextField.becomeFirstResponder()
        } else {
            textView.becomeFirstResponder()
        }
        
        return true
    }
    
}

extension FeedbackController: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholder
            textView.textColor = .placeholderText
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholder && textView.textColor == .placeholderText {
            textView.text = ""
            textView.textColor = .label
        }
    }
    
}
