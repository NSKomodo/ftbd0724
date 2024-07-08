//
//  WorkoutTest.swift
//  ORMTests
//
//  Created by Jorge Tapia on 7/7/24.
//

import XCTest
@testable import ORM

/// Class that tests the `WorkoutDataService` code.
final class WorkoutTests: XCTestCase {
    func testOneRepMax() {
        guard let date = DateHelper.parseWorkoutDate(from: "Oct 05 2020") else {
            XCTFail()
            return
        }
        
        let exercise = "Barbell Bench Press"
        let reps = 4
        let weight = 45.0
        
        let workout = Workout(date: date,
                              exercise: exercise,
                              repetitions: reps,
                              weight: weight)
        
        let sampleOneRepMax = weight * (36 / Double(37 - reps))
        let testOneRepMax = workout.oneRepMax
        
        XCTAssertEqual(testOneRepMax, sampleOneRepMax)
    }
}

