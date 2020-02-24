//
//  TableViewPlaceholderView.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-12-31.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import UIKit

final class TableViewPlaceholderView: UIView {
    
    // MARK: Attributes
    
    let configuration: Configuration
    
    // MARK: Subviews
    
    private lazy var container = UIView()
    
    private lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .gray
        lbl.font = .systemFont(ofSize: 18, weight: .semibold)
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.text = configuration.text
        return lbl
    }()
    
    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = configuration.image.withRenderingMode(.alwaysTemplate)
        iv.tintColor = .gray
        return iv
    }()
    
    // MARK: Lifecycle
    
    init(configuration: Configuration) {
        self.configuration = configuration
        super.init(frame: .zero)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TableViewPlaceholderView {
    
    struct Configuration {
        let image: UIImage
        let text: String
    }
    
}

private extension TableViewPlaceholderView {
    
    func configureLayout() {
        addSubview(container)
        
        container.addSubview(titleLabel)
        container.addSubview(imageView)
        
        container.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.leading.trailing.equalTo(self).inset(24)
        }
        
        imageView.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalTo(container)
            make.height.equalTo(90)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(12)
            make.leading.bottom.trailing.equalTo(container)
        }
        
    }
    
}
