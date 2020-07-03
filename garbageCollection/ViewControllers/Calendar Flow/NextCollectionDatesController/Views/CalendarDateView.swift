//
//  CalendarDateView.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2020-07-03.
//  Copyright © 2020 Raphael Inc. All rights reserved.
//

import UIKit

class CalendarDateView: UIView {
    
    // MARK: Attributes
    
    let date: Date
    
    // MARK: Subviews
    
    private lazy var wrapperView: UIView = {
        let v = UIView()
        v.clipsToBounds = true
        v.layer.cornerRadius = 12
        return v
    }()
    
    private lazy var redHeaderView: UIView = {
        let v = UIView()
        v.backgroundColor = .lightRed
        return v
    }()
    
    private lazy var dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.adjustsFontSizeToFitWidth = true
        lbl.textAlignment = .center
        if #available(iOS 13, *) {
            lbl.font = .roundedFont(ofSize: 18, weight: .semibold)
        } else {
            lbl.font = .systemFont(ofSize: 18, weight: .semibold)
        }
        
        return lbl
    }()
    
    init(date: Date) {
        self.date = date
        super.init(frame: .zero)
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
        
        layer.applySketchShadow(alpha: 0.21, x: 0, y: 2, blur: 10, spread: 0)
        dateLabel.text = date.formatted(as: .dayMonthMultiline).uppercased()
        backgroundColor = .white
    }
    
    func configureLayout() {
        
        addSubview(wrapperView)
        wrapperView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 55, height: 55))
        }
        
        wrapperView.addSubview(redHeaderView)
        redHeaderView.snp.makeConstraints { (make) in
            make.height.equalTo(12)
            make.leading.top.trailing.equalToSuperview()
        }
        
        wrapperView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(redHeaderView.snp.bottom).offset(4)
            make.leading.trailing.bottom.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 8, bottom: 4, right: 8))
        }
    }
    
}
