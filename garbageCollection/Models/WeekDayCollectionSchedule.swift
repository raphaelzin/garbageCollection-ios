//
//  WeekDaySchedule.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-10-21.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import Foundation
import Differentiator

struct WeekDayCollectionSchedule {
    let shift: CollectionSchedule.Shift
    let schedule: CollectionSchedule.Schedule
    let weekday: Date.WeekDay
    
    let neighbourhoodId: String
}

extension WeekDayCollectionSchedule: IdentifiableType {
    
    var identity: Int { "\(weekday.fullname) \(neighbourhoodId)".hash }
    
}

extension WeekDayCollectionSchedule: Equatable {
    static func == (lhs: WeekDayCollectionSchedule, rhs: WeekDayCollectionSchedule) -> Bool {
        lhs.identity == rhs.identity
    }
}
