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
        iv.tintColor = .white
        return iv
    }()
    
    private lazy var weekDayLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private lazy var scheduleDetailsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        return label
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.white.cgColor
        return view
    }()
    
    // Init method
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dropShadow()
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let fromWidth: CGFloat = !highlighted ? 2 : 0
        let toWidth: CGFloat =  highlighted ? 2 : 0
        let animation: CABasicAnimation = CABasicAnimation(keyPath: "borderWidth")
        
        animation.fromValue = fromWidth
        animation.toValue = toWidth
        animation.duration = 0.25
        containerView.layer.add(animation, forKey: "Width")
        containerView.layer.borderWidth = toWidth

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) { }
    
}

// MARK: Public configuration methods

extension ScheduledCollectionCell {

    func configure(with collectionSchedule: WeekDayCollectionSchedule) {
        weekDayLabel.text = collectionSchedule.weekday.fullname
        scheduleDetailsLabel.text = collectionSchedule.schedule.description
        shiftIconImageView.image = collectionSchedule.shift.icon
        
        containerView.backgroundColor = collectionSchedule.shift.tint
    }
    
}

// MARK: Private layout methods

private extension ScheduledCollectionCell {
    
    func configureView() {
        backgroundColor = .clear
    }
    
    func configureLayout() {
        addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.edges.equalTo(self).inset(UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12))
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
            make.top.equalTo(weekDayLabel.snp.bottom).offset(2)
            make.leading.equalTo(shiftIconImageView.snp.trailing).offset(16)
            make.trailing.equalTo(containerView).offset(-16)
            make.bottom.equalTo(containerView).offset(-14)
        }
    }
    
    /// Drop shadow for container view
    func dropShadow() {
        let shadowPath = UIBezierPath(roundedRect: containerView.frame, cornerRadius: 10).cgPath
        containerView.layer.shadowPath = shadowPath
        containerView.layer.shadowRadius = 4
        containerView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        containerView.layer.shadowOffset = CGSize(width: -8, height: -3)
        containerView.layer.shadowOpacity = 0.5
    }
    
}
