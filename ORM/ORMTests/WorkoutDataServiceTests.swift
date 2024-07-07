//
//  WorkoutDataServiceTests.swift
//  ORMTests
//
//  Created by Jorge Tapia on 7/7/24.
//

import XCTest
@testable import ORM

/// Class that tests the `WorkoutDataService` code.
final class WorkoutDataServiceTests: XCTestCase {
    /// The service instance to be used during tests.
    var service: WorkoutDataService?
    
    override func setUpWithError() throws {
        service = WorkoutDataService.shared
    }
    
    /// Tests the `loadDataFile` method.
    func testLoadDataFile() {
        var dataFileAsset: NSDataAsset?
        if dataFileAsset == nil {
            dataFileAsset = NSDataAsset(name: "workoutData")
            if dataFileAsset == nil {
                let message = String(localized: "WorkoutDataError.dataFile")
                XCTFail(message)
            }
        }
        
        do {
            try service?.loadDataFile()
            XCTAssertEqual(service?.dataFileAsset, dataFileAsset)
            dataFileAsset = nil
        } catch WorkoutDataError.dataFile {
            let message = String(localized: "WorkoutDataError.dataFile")
            XCTFail(message)
        } catch {
            let message = String(localized: "WorkoutDataError.unexpected")
            XCTFail(message)
        }
    }
    
    /// Tests the `parseRow` method.
    func testParseRow() {
        let failMessage = String(localized: "WorkoutDataError.invalidRow")
        
        let sampleRow = "Oct 05 2020,Barbell Bench Press,4,45"
        let fields = sampleRow.split(separator: ",")
        if fields.count != 4 {
            XCTFail(failMessage)
        }
        
        // Extract fields from row and covert them from String.Subsequence to String
        let dateField = String(fields[0])
        let exerciseField = String(fields[1])
        let repsField = String(fields[2])
        let weightField = String(fields[3])
        
        // Cast fields to expected types
        guard let date = DateHelper.parseWorkoutDate(from: dateField),
              let reps = Int(repsField),
              let weight = Double(weightField) else {
            
            XCTFail(failMessage)
            return
        }
        
        do {
            // Test happy path
            let sampleWorkout = Workout(date: date,
                                        exercise: exerciseField,
                                        repetitions: reps,
                                        weight: weight)
            let testWorkout = try service?.parseRow(row: sampleRow)
            XCTAssertEqual(testWorkout, sampleWorkout)
            
            // Test corrupted date
            let invalidDateRow = "No date,Barbell Bench Press,4,45"
            XCTAssertThrowsError(try service?.parseRow(row: invalidDateRow)) { error in
                if let error = error as? WorkoutDataError {
                    XCTAssertEqual(error, WorkoutDataError.invalidDateFormat)
                }
            }
            
            // Test corrupted repetitions
            let invalidRepsRow = "Oct 05 2020,Barbell Bench Press,reps,45"
            XCTAssertThrowsError(try service?.parseRow(row: invalidRepsRow)) { error in
                if let error = error as? WorkoutDataError {
                    XCTAssertEqual(error, WorkoutDataError.invalidRow)
                }
            }
            
            // Test corrupted weight
            let invalidWeightRow = "Oct 05 2020,Barbell Bench Press,4,weight"
            XCTAssertThrowsError(try service?.parseRow(row: invalidWeightRow)) { error in
                if let error = error as? WorkoutDataError {
                    XCTAssertEqual(error, WorkoutDataError.invalidRow)
                }
            }
            
            // Test for empty row
            let emptyRow = ""
            XCTAssertThrowsError(try service?.parseRow(row: emptyRow)) { error in
                if let error = error as? WorkoutDataError {
                    XCTAssertEqual(error, WorkoutDataError.invalidRow)
                }
            }
        } catch WorkoutDataError.invalidRow {
            XCTFail(failMessage)
        } catch {
            XCTFail(error.localizedDescription)
        }
        
    }

    override func tearDownWithError() throws {
        service = nil
    }
}

