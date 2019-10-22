//
//  ScheduledCollectionCell.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-10-19.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import UIKit

class ScheduledCollectionCell: UITableViewCell {
    
    // Subviews
    
    private lazy var shiftIconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private lazy var weekDayLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var scheduleDetailsLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        return view
    }()
    
    // Init method
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: Public configuration methods

extension ScheduledCollectionCell {

    func configure(with collectionSchedule: WeekDayCollectionSchedule) {
        weekDayLabel.text = collectionSchedule.weekday.fullname
        scheduleDetailsLabel.text = collectionSchedule.schedule.description
        shiftIconImageView.image = collectionSchedule.shift.icon
        
        backgroundColor = collectionSchedule.shift.tint
    }
    
}

// MARK: Private layout methods

private extension ScheduledCollectionCell {
    
    func configureLayout() {
        addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.edges.equalTo(self).inset(UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12))
            make.height.equalTo(70)
        }
        
        containerView.addSubview(shiftIconImageView)
        shiftIconImageView.snp.makeConstraints { (make) in
            make.leading.equalTo(containerView).offset(16)
            make.size.equalTo(CGSize(width: 38, height: 38))
            make.centerY.equalTo(containerView)
        }
        
        containerView.addSubview(weekDayLabel)
        weekDayLabel.snp.makeConstraints { (make) in
            make.height.equalTo(18)
            make.leading.equalTo(shiftIconImageView.snp.trailing).offset(16)
            make.trailing.equalTo(containerView).offset(-16)
            make.top.equalTo(containerView).offset(18)
        }
        
        containerView.addSubview(scheduleDetailsLabel)
        scheduleDetailsLabel.snp.makeConstraints { (make) in
            make.top.equalTo(weekDayLabel.snp.bottom).offset(8)
            make.leading.equalTo(shiftIconImageView.snp.trailing).offset(16)
            make.trailing.equalTo(containerView).offset(-16)
        }
    }
    
}
