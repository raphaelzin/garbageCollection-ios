//
//  SplashController.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-10-17.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import UIKit
import RxSwift

protocol SplashControllerDelegate: class {
    func didFinishLoading()
}

class SplashController: UIViewController {
    
    // MARK: Attributes
    
    weak var delegate: SplashControllerDelegate?
    
    private let disposeBag = DisposeBag()
    
    private var timer: Timer?
    
    private var currentMessageIndex: Int = 0
    
    private let messages = ["Carregando...",
                            "Levando o lixo pra fora",
                            "Pondo o lixo no canto",
                            "Esperando o caminhão passar",
                            "hmm, tá demorando pra carregar, né?",
                            "Relaxa, já que termina ;)"]
    
    // MARK: Subviews
    
    private lazy var trashCanIcon: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .white
        iv.image = UIImage(systemName: "trash")?.withRenderingMode(.alwaysTemplate).withTintColor(.white)
        return iv
    }()
    
    private lazy var appTitle: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 24, weight: .bold)
        lbl.textColor = .white
        lbl.text = "Coleta Fortaleza"
        return lbl
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .medium)
        ai.startAnimating()
        ai.color = .white
        return ai
    }()
    
    private lazy var sillyMessageLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 18, weight: .medium)
        lbl.textColor = .white
        lbl.text = messages.first
        lbl.textAlignment = .center
        return lbl
    }()
    
    // MARK: Lifecycle
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setupTimer()
        configureView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: Private methods

private extension SplashController {
    
    func setupTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.5,
                                     target: self,
                                     selector: #selector(updateMessage),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    @objc func updateMessage() {
        if currentMessageIndex >= messages.count {
            timer?.invalidate()
        } else {
            sillyMessageLabel.text = messages[currentMessageIndex]
            currentMessageIndex += 1
        }
        
    }
    
}

// MARK: Perform loadings

extension SplashController {
    
    func updateData() {
        guard let installation = Installation.current(), installation.objectId != nil else {
            delegate?.didFinishLoading()
            return
        }
        
        installation.rx
            .fetch()
            .flatMapCompletable { (installation) -> Completable in
                guard let installation = installation as? Installation,
                    let neighbourhood = installation.neighbourhood else { return .empty() }
                
                return neighbourhood.rx.fetch().asCompletable()
            }.subscribe(onCompleted: { [weak self] in
                self?.delegate?.didFinishLoading()
            }, onError: { [weak self] error in
                print("Error: \(error)")
                self?.delegate?.didFinishLoading()
            }).disposed(by: disposeBag)
    }
    
}

// MARK: Private layout methods

private extension SplashController {
    
    func configureView() {
        view.backgroundColor = .defaultBlue
    }
    
    func configureLayout() {
        view.addSubview(trashCanIcon)
        trashCanIcon.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 134, height: 154))
            make.centerX.equalTo(view)
            make.centerY.equalTo(view).offset(-60)
        }
        
        view.addSubview(appTitle)
        appTitle.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(trashCanIcon.snp.bottom).offset(8)
        }
        
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(appTitle.snp.bottom).offset(24)
        }
        
        view.addSubview(sillyMessageLabel)
        sillyMessageLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.leading.trailing.equalTo(view).inset(16)
            make.top.equalTo(activityIndicator.snp.bottom).offset(16)
        }
    }
    
}
