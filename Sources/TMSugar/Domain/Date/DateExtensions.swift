//
//  File.swift
//  TMSugar
//
//  Created by Kostiantyn Kolosov on 24.03.2025.
//

import Foundation

/// Extension for Date to handle week-related calculations
public extension Date {
    // MARK: - Day

    /**
     Returns zero-based index of the day of the week (0-6, where 0 is Sunday).
     
     - Returns: Optional Int representing day index (0-6) or nil if calculation fails
     */
    var dayOfWeekIndex: Int? {
        return dayOfWeekNumber.map { $0 - 1 }
    }

    /**
     Returns number of the day of the week (1-7, where 1 is Sunday).
     
     - Returns: Optional Int representing day index (1-7) or nil if calculation fails
     */
    var dayOfWeekNumber: Int? {
        let weekday = Calendar.current.dateComponents([.weekday], from: self).weekday
        return weekday.map { $0 }
    }

    // MARK: - Month
    /**
     Returns zero-based index of the current month (0-11, where 0 is January).
     
     - Returns: Optional Int representing month index (0-11) or nil if calculation fails
     */
    var currentMonthIndex: Int? {
        return currentMonthNumber.map({ $0 - 1 })
    }

    /**
     Returns number of the current month (1-12, where 1 is January).
     
     - Returns: Optional Int representing month number (1-12) or nil if calculation fails
     */
    var currentMonthNumber: Int? {
        Calendar.current.dateComponents([.month], from: self).month
    }
}
