//
//  CalendarDateView.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2020-07-03.
//  Copyright © 2020 Raphael Inc. All rights reserved.
//

import UIKit

class CalendarDateView: UIView {
    
    // MARK: Subviews
    
    private lazy var redHeaderView: UIView = {
        let v = UIView()
        v.backgroundColor = .lightRed
        return v
    }()
    
    private lazy var dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        if #available(iOS 13, *) {
            lbl.font = .roundedFont(ofSize: 18, weight: .semibold)
        } else {
            lbl.font = .systemFont(ofSize: 18, weight: .semibold)
        }
        
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension CalendarDateView {
    
    func configureView() {
        layer.cornerRadius = 12
        clipsToBounds = true
    }
    
    func configureLayout() {
        
        snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 55, height: 55))
        }
        
        addSubview(redHeaderView)
        redHeaderView.snp.makeConstraints { (make) in
            make.height.equalTo(12)
            make.leading.top.trailing.equalToSuperview()
        }
        
        addSubview(dateLabel)
        dateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(redHeaderView.snp.bottom).offset(4)
            make.leading.trailing.bottom.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 8, bottom: 4, right: 8))
        }
    }
    
}
