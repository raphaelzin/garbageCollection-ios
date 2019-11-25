//
//  PictureSelectionView.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-11-23.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import UIKit

protocol PictureSelectionViewDelegate: class {
    func didRequestPicture(from pictureSelectionView: PictureSelectionView)
}

class PictureSelectionView: UIView {
    
    // MARK: Attributes
    
    weak var delegate: PictureSelectionViewDelegate?
    
    // MARK: Subviews
    
    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.tintColor = .defaultBlue
        return iv
    }()
    
    private lazy var infoStack: UIStackView = {
        let stv = UIStackView()
        stv.alignment = .center
        stv.axis = .vertical
        stv.distribution = .fillProportionally
        return stv
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.6)
        return view
    }()
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        configureStack()
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onViewTap)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: Private selectors

private extension PictureSelectionView {
    
    @objc func onViewTap() {
        delegate?.didRequestPicture(from: self)
    }
    
}

// MARK: Private layout methods

private extension PictureSelectionView {
    
    func configureLayout() {
        
        snp.makeConstraints { (make) in
            make.height.equalTo(200)
        }
        
        addSubview(infoStack)
        infoStack.snp.makeConstraints { (make) in
            make.center.equalTo(self)
        }
        
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        addSubview(separatorView)
        separatorView.snp.makeConstraints { (make) in
            make.leading.bottom.trailing.equalTo(self)
            make.height.equalTo(0.5)
        }
    }
    
    func configureStack() {
        let cameraPic = UIImageView(image: UIImage(systemName: "photo"))
        cameraPic.contentMode = .scaleAspectFit
        cameraPic.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 72, height: 40))
        }
        
        let label = UILabel()
        label.text = "Selecionar foto"
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .defaultBlue
        
        infoStack.addArrangedSubview(cameraPic)
        infoStack.addArrangedSubview(label)
    }
    
}
