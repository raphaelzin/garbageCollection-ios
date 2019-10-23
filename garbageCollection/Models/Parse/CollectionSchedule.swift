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
    var typedDays: [WeekDay] {
        days.compactMap { WeekDay(rawValue: $0) }
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
            guard #available(iOS 13, *) else { return nil }
            
            switch self {
            case .morning: return UIImage(systemName: "sun.max")!
            case .night: return UIImage(systemName: "moon")!
            }
        }
        
        var tint: UIColor {
            switch self {
            case .morning: return .lighterBlue
            case .night: return .darkerBlue
            }
        }
    }
    
    enum WeekDay: String {
        case mon = "seg"
        case tue = "ter"
        case wed = "qua"
        case thu = "qui"
        case fri = "sex"
        case sat = "sab"
        case sun = "dom"
        
        var fullname: String {
            switch self {
            case .mon: return "Segunda feira"
            case .tue: return "Terça feira"
            case .wed: return "Quarta feira"
            case .thu: return "Quinta feira"
            case .fri: return "Sexta feira"
            case .sat: return "Sábado"
            case .sun: return "Domingo"
            }
        }
    }
    
    enum Schedule {
        case specificTime(String)
        case timeWindow(String, String)
        
        init?(raw: String) {
            let noSpacesRaw = raw.replacingOccurrences(of: " ", with: "")
            let timeComponents = noSpacesRaw.split(separator: "-").map { String($0) }
            
            guard (timeComponents.allSatisfy { $0.isValidTime }) else { return nil }
            
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
