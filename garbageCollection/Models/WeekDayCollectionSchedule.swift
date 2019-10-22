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
    let weekday: CollectionSchedule.WeekDay
    
    let neighbourhoodId: String
}

extension WeekDayCollectionSchedule: IdentifiableType {
    typealias Identity = Int
    
    var identity: Int {
        return "\(weekday.fullname) \(neighbourhoodId)".hash
    }
}

extension WeekDayCollectionSchedule: Equatable {
    static func == (lhs: WeekDayCollectionSchedule, rhs: WeekDayCollectionSchedule) -> Bool {
        return lhs.identity == rhs.identity
    }
}
