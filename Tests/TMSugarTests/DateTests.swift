//
//  DateTests.swift
//  TMSugar
//
//  Created by Kostiantyn Kolosov on 24.03.2025.
//

import XCTest
@testable import TMSugar

class DateTests: XCTestCase {
    
    // MARK: - Helper Methods
    
    /**
     Creates Date object for specific day of week
     
     - Parameters:
        - weekday: Number representing weekday (1-7, where 1 is Sunday)
     - Returns: Date object representing specified weekday
     */
    private func createDate(weekday: Int) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components.weekday = weekday
        components.year = 2024
        components.month = 1
        
        // Setting the day of month to match required weekday
        // January 2024: 1st is Monday
        switch weekday {
        case 1: components.day = 7  // Sunday
        case 2: components.day = 1  // Monday
        case 3: components.day = 2  // Tuesday
        case 4: components.day = 3  // Wednesday
        case 5: components.day = 4  // Thursday
        case 6: components.day = 5  // Friday
        case 7: components.day = 6  // Saturday
        default: components.day = 1
        }
        
        guard let date = calendar.date(from: components) else {
            fatalError("Failed to create date with weekday \(weekday)")
        }
        
        // Verify that created date has correct weekday
        let resultWeekday = calendar.component(.weekday, from: date)
        assert(resultWeekday == weekday, "Created date has wrong weekday")
        
        return date
    }
    
    // MARK: - dayOfWeekNumber Tests
    
    func testDayOfWeekNumber_Sunday() {
        let sunday = createDate(weekday: 1)
        XCTAssertEqual(sunday.dayOfWeekNumber, 1, "Sunday should return 1")
    }
    
    func testDayOfWeekNumber_Wednesday() {
        let wednesday = createDate(weekday: 4)
        XCTAssertEqual(wednesday.dayOfWeekNumber, 4, "Wednesday should return 4")
    }
    
    func testDayOfWeekNumber_Saturday() {
        let saturday = createDate(weekday: 7)
        XCTAssertEqual(saturday.dayOfWeekNumber, 7, "Saturday should return 7")
    }
    
    // MARK: - dayOfWeekIndex Tests
    
    func testDayOfWeekIndex_Sunday() {
        let sunday = createDate(weekday: 1)
        XCTAssertEqual(sunday.dayOfWeekIndex, 0, "Sunday should return index 0")
    }
    
    func testDayOfWeekIndex_Wednesday() {
        let wednesday = createDate(weekday: 4)
        XCTAssertEqual(wednesday.dayOfWeekIndex, 3, "Wednesday should return index 3")
    }
    
    func testDayOfWeekIndex_Saturday() {
        let saturday = createDate(weekday: 7)
        XCTAssertEqual(saturday.dayOfWeekIndex, 6, "Saturday should return index 6")
    }
}
