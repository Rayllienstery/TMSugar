//
//  DateMonthExtensionTests.swift
//  TMSugar
//
//  Created by Kostiantyn Kolosov on 24.03.2025.
//

import XCTest
@testable import TMSugar

// MARK: - Month Tests
class DateMonthExtensionTests: XCTestCase {
    
    /**
     Creates Date object for specific month
     
     - Parameters:
        - month: Number representing month (1-12, where 1 is January)
     - Returns: Date object representing specified month
     */
    private func createDate(month: Int) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components.year = 2024
        components.month = month
        components.day = 1
        
        guard let date = calendar.date(from: components) else {
            fatalError("Failed to create date with month \(month)")
        }
        return date
    }
    
    // MARK: - currentMonthNumber Tests
    
    func testCurrentMonthNumber_January() {
        let january = createDate(month: 1)
        XCTAssertEqual(january.currentMonthNumber, 1, "January should return 1")
    }
    
    func testCurrentMonthNumber_June() {
        let june = createDate(month: 6)
        XCTAssertEqual(june.currentMonthNumber, 6, "June should return 6")
    }
    
    func testCurrentMonthNumber_December() {
        let december = createDate(month: 12)
        XCTAssertEqual(december.currentMonthNumber, 12, "December should return 12")
    }
    
    // MARK: - currentMonthIndex Tests
    
    func testCurrentMonthIndex_January() {
        let january = createDate(month: 1)
        XCTAssertEqual(january.currentMonthIndex, 0, "January should return index 0")
    }
    
    func testCurrentMonthIndex_June() {
        let june = createDate(month: 6)
        XCTAssertEqual(june.currentMonthIndex, 5, "June should return index 5")
    }
    
    func testCurrentMonthIndex_December() {
        let december = createDate(month: 12)
        XCTAssertEqual(december.currentMonthIndex, 11, "December should return index 11")
    }
}
