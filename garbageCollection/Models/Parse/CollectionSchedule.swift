//
//  CollectionSchedule.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-10-20.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import Foundation
import Parse

class CollectionSchedule: PFObject, PFSubclassing {
    
    @NSManaged var identifier: String?
    @NSManaged var cityName: String?
    @NSManaged var neighbourhoodName: String?
    
    // Types to be validated
    @NSManaged private var days: [String]
    @NSManaged private var schedule: String?
    @NSManaged private var shift: String?
    
    // Pointers
    @NSManaged var neighbourhood: Neighbourhood?
    @NSManaged var city: City?
    
    // Validated types
    var typedDays: [Date.WeekDay] {
        days.compactMap { Date.WeekDay(rawValue: $0) }
    }
    
    var typedSchedule: Schedule? {
        Schedule(raw: schedule ?? "")
    }
    
    var typedShift: Shift? {
        Shift(rawValue: shift ?? "")
    }
    
    // Helper getters
    var weeklyCollection: [WeekDayCollectionSchedule] {
        guard let shift = typedShift, let schedule = typedSchedule else { return [] }
        return typedDays.compactMap {
            WeekDayCollectionSchedule(shift: shift, schedule: schedule, weekday: $0, neighbourhoodId: identifier ?? "")
        }
    }
    
    static func parseClassName() -> String { "CollectionSchedule" }
    
}

// MARK: Custom Subtypes

extension CollectionSchedule {
    
    enum Shift: String {
        case morning = "DIURNO"
        case night = "NOTURNO"
        
        var icon: UIImage? {
            switch self {
            case .morning: return UIImage(symbol: "sun.max")!
            case .night: return UIImage(symbol: "moon")!
            }
        }
        
        var tint: UIColor {
            switch self {
            case .morning: return .lighterBlue
            case .night: return .darkerBlue
            }
        }
    }
    
    enum Schedule {
        case specificTime(Date.Time)
        case timeWindow(Date.Time, Date.Time)
        
        init?(raw: String) {
            let noSpacesRaw = raw.replacingOccurrences(of: " ", with: "")
            let rawTimeComponents = noSpacesRaw.split(separator: "-").map { Date.Time(String($0)) }
            let timeComponents = rawTimeComponents.compactMap { $0 }
            guard rawTimeComponents.count == timeComponents.count else { return nil }
            
            if timeComponents.count == 2 {
                self = .timeWindow(timeComponents.first!, timeComponents.last!)
            } else if timeComponents.count == 1 {
                self = .specificTime(timeComponents.first!)
            } else {
                debugPrint("Invalid number of components for raw: \(raw)")
                return nil
            }
        }
        
        var description: String {
            switch self {
            case .specificTime(let schedule): return "Às \(schedule)"
            case .timeWindow(let start, let end): return "Entre \(start) e \(end)"
            }
        }
    }

}

// MARK: Properties

extension CollectionSchedule {
    
    struct Properties {
        static let identifier = "identifier"
        static let cityName = "cityName"
        static let neighbourhoodName = "neighbourhoodName"
        static let days = "days"
        static let schedule = "schedule"
        static let shift = "shift"
        static let neighbourhood = "neighbourhood"
        static let city = "city"
    }
    
}
