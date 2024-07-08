//
//  DateHelperTests.swift
//  ORMTests
//
//  Created by Jorge Tapia on 7/7/24.
//

import XCTest
@testable import ORM

/// Class that tests the `DateHelper` code.
final class DateHelperTests: XCTestCase {
    /// Tests the `parseWorkoutDate` function.
    func testParseWorkoutDate() {
        let sampleDateField = "Oct 05 2020"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateHelper.dateFormat
        let sampleDate = dateFormatter.date(from: sampleDateField)
        let testDate = DateHelper.parseWorkoutDate(from: sampleDateField)
        XCTAssertEqual(testDate, sampleDate)
        
        let invalidDateField = "Today is Sunday"
        let invalidDate = DateHelper.parseWorkoutDate(from: invalidDateField)
        XCTAssertNil(invalidDate)
    }
}

