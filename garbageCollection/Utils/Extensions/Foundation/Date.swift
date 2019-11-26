//
//  Date.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-10-27.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import Foundation

extension Date {
    
    enum Format: String {
        case hourAndDate = "HH:MM - EEEE, d MMM"
    }
    
    func formatted(as format: Format) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.string(from: self)
    }
    
    func next(_ weekday: WeekDay, at time: Time? = nil, direction: Calendar.SearchDirection = .forward, considerToday: Bool = false) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        let components = DateComponents(hour: time?.hours, minute: time?.minutes, weekday: weekday.index)

        if considerToday && calendar.component(.weekday, from: self) == weekday.index {
            return self
        }

        return calendar.nextDate(after: self,
                                 matching: components,
                                 matchingPolicy: .nextTime,
                                 direction: direction)!
    }
    
    enum WeekDay: String, CaseIterable {
        case sun = "dom"
        case mon = "seg"
        case tue = "ter"
        case wed = "qua"
        case thu = "qui"
        case fri = "sex"
        case sat = "sab"
        
        var fullname: String {
            switch self {
            case .sun: return "Domingo"
            case .mon: return "Segunda feira"
            case .tue: return "Terça feira"
            case .wed: return "Quarta feira"
            case .thu: return "Quinta feira"
            case .fri: return "Sexta feira"
            case .sat: return "Sábado"
            }
        }
        
        var index: Int {
            WeekDay.allCases.firstIndex(of: self)! + 1
        }
    }
    
    struct Time: CustomStringConvertible {
        
        let hours: Int
        let minutes: Int
        
        init?(_ rawString: String) {
            guard rawString.isValidTime else { return nil }
            let components = rawString.components(separatedBy: ":").compactMap { Int($0) }
            
            self.hours = components[0]
            self.minutes = components[1]
        }
        
        var description: String {
            [hours, minutes].map { $0 < 10 ? "0\($0)" : "\($0)" }.joined(separator: ":")
        }
        
    }

}
