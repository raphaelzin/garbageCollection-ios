//
//  garbageCollectionModelTests.swift
//  garbageCollectionTests
//
//  Created by Raphael Souza on 2019-10-20.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import XCTest
import Parse
@testable import garbageCollection

class garbageCollectionModelTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

func test_collection_schedule_shift() {
        let morningShift = "DIURNO"
        let nightShift   = "NOTURNO"
        let invalidShift = "DIA"
        let invalidShift2 = "NOITE"
        let emptyShift = ""
        
        XCTAssert(CollectionSchedule.Shift(rawValue: morningShift) == .some(.morning), "Invalid parsing of shift for \(morningShift).")
        XCTAssert(CollectionSchedule.Shift(rawValue: nightShift) == .some(.night), "Invalid parsing of shift for \(nightShift).")
        XCTAssertNil(CollectionSchedule.Shift(rawValue: invalidShift), "Invalid parsing of shift for \(invalidShift).")
        XCTAssertNil(CollectionSchedule.Shift(rawValue: invalidShift2), "Invalid parsing of shift for \(invalidShift2).")
        XCTAssertNil(CollectionSchedule.Shift(rawValue: emptyShift), "Invalid parsing of shift for \(emptyShift).")
    }
    
    
    func test_collection_schedule_weekdays() {
        let validDays = ["seg", "ter", "qua", "qui", "sex", "sab", "dom"]
        let oneInvalid = ["seg", "ter", "qxa"]
        
        XCTAssertTrue(validDays.allSatisfy { CollectionSchedule.WeekDay(rawValue: $0) != nil }, "A valid day in \(validDays) is not being accepted.")
        XCTAssertFalse(oneInvalid.allSatisfy { CollectionSchedule.WeekDay(rawValue: $0) != nil }, "An invalid day in \(oneInvalid) is incorrectly being accepted.")
    }
    
    func test_collection_schedule_schedules() {
        let validSpecificSchedule = "19:00"
        let invalidSpecificSchedule = "25:00"
        let validWindowSchedule = "9:00 - 11:00"
        let invalidWindowSchedule1 = "11:10 - 44:10"
        let invalidWindowSchedule2 = "11:62 - 14:10"
        let invalidWindowSchedule3 = "11:50 -- 14:10"
        
        switch CollectionSchedule.Schedule(raw: validSpecificSchedule) {
        case .some(.specificTime(let time)): XCTAssertTrue(time == "19:00", "Valid \(validSpecificSchedule) specific schedule.")
        default: XCTFail("\(validSpecificSchedule) was not parsed as a valid specific schedule.")
        }
        
        XCTAssertNil(CollectionSchedule.Schedule(raw: invalidSpecificSchedule), "\(invalidSpecificSchedule) was parsed as a valid specific schedule.")
        
        switch CollectionSchedule.Schedule(raw: validWindowSchedule) {
        case .some(.timeWindow(let start, let end)): XCTAssertTrue(start == "9:00" && end == "11:00", "\(validWindowSchedule) was parsed as an invalid time window")
        default: XCTFail("\(validWindowSchedule) was parsed as an invalid time window")
        }
        
        XCTAssertNil(CollectionSchedule.Schedule(raw: invalidWindowSchedule1), "\(invalidWindowSchedule1) was parsed as a valid window schedule.")
        
        XCTAssertNil(CollectionSchedule.Schedule(raw: invalidWindowSchedule2), "\(invalidWindowSchedule2) was parsed as a valid window schedule.")
        
        XCTAssertNil(CollectionSchedule.Schedule(raw: invalidWindowSchedule3), "\(invalidWindowSchedule3) was parsed as a valid window schedule.")
        
    }
}
