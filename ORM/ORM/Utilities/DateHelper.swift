//
//  DateHelper.swift
//  ORM
//
//  Created by Jorge Tapia on 7/7/24.
//

import Foundation

/// Provides helper methods to process and format dates.
struct DateHelper {
    /// The date format to parse workout data rows.
    static let dateFormat = "MMM dd yyyy"
    
    /// Parses a workout date from a data row inside he historical data file.
    /// - Parameter dateField: The extracted date field from the workout row.
    /// - Returns: A parsed `Date` object representation of the date field.
    static func parseWorkoutDate(from dateField: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateHelper.dateFormat
        return dateFormatter.date(from: dateField)
    }
}

