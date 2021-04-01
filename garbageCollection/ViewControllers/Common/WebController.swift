//
//  WebController.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-12-08.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import UIKit
import WebKit

protocol WebControllerCoordinatorDelegate: class {
    func didRequestDismiss(controller: WebController)
}

enum LinkType {
    case sourceCode
    case custom(title: String, url: String)
    
    var title: String {
        switch self {
        case .sourceCode: return "Código Fonte"
        case .custom(let title, _): return title
        }
    }
    
    var url: URL? {
        switch self {
        case .sourceCode: return URL(string: "https://github.com/raphaelzin/garbageCollection-ios")
        case .custom(_, let url): return URL(string: url)
        }
    }
}

class WebController: UIViewController {
    
    // MARK: Attributes
    
    private var linkType: LinkType?
    private var observer: NSKeyValueObservation?
    
    weak var coordinatorDelegate: WebControllerCoordinatorDelegate?
    
    // MARK: Subviews
    
    private lazy var webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        return webView
    }()
    
    private lazy var progressView: UIProgressView = {
        let pv = UIProgressView(progressViewStyle: .default)
        pv.trackTintColor = .veryLightGray
        pv.progressTintColor = .coolGreen
        return pv
    }()
    
    // MARK: Lifecycle
    
    init(linkType: LinkType) {
        self.linkType = linkType
        super.init(nibName: nil, bundle: nil)
        
        configureLayout()
        configureView()
        configureNavBar()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private methods

private extension WebController {
    func configureLayout() {
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
        
        view.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.height.equalTo(2)
            make.leading.top.trailing.equalTo(self.view)
        }
    }
    
    func configureNavBar() {
        navigationItem.title = linkType?.title
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Fechar",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(closeWebView))
        // Load web view with url supplied
        guard let url = self.linkType?.url else { return }
        webView.load(URLRequest(url: url))
    }
    
    func configureView() {
        // Create observer to track loading progress of the web page
        observer = webView.observe(\.estimatedProgress, options: [.new]) { [weak self] webView, _ in
            self?.progressView.isHidden = webView.estimatedProgress == 1
            self?.progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        }
    }
    
}

// MARK: Selectors

extension WebController {
    
    @objc private func closeWebView() {
        coordinatorDelegate?.didRequestDismiss(controller: self)
    }
    
}

extension WebController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        coordinatorDelegate?.didRequestDismiss(controller: self)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.isHidden = true
    }
    
}
