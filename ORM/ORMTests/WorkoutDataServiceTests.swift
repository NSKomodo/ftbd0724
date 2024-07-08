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
    var service: WorkoutDataService!
    
    override func setUpWithError() throws {
        service = WorkoutDataService.shared
    }
    
    /// Tests the `loadWorkoutDataFile` method.
    func testLoadWorkoutDataFile() async {
        // Ensure the file exists at the passed URL
        guard let url = Bundle.main.url(forResource: WorkoutDataService.dataFileName,
                                        withExtension: WorkoutDataService.dataFileExtension),
              FileManager.default.fileExists(atPath: url.path) else {
            
            let message = String(localized: "WorkoutDataError.dataFileNotFound")
            XCTFail(message)
            return
        }
        
        do {
            // Read the file data asynchoronously
            let data = try await withCheckedThrowingContinuation { continuation in
                DispatchQueue.global().async {
                    do {
                        let data = try Data(contentsOf: url)
                        continuation.resume(returning: data)
                    } catch {
                        continuation.resume(throwing: WorkoutDataError.invalidDataFile)
                    }
                }
            }
            
            let sampleFileContents = String(data: data, encoding: .utf8)
            let testFileContents = try await service.loadWorkoutDataFile(atPath: url)
            XCTAssertEqual(testFileContents, sampleFileContents)
            
            // Test invalid file
            guard Bundle.main.url(forResource: "testFileName",
                                  withExtension: "testExtension") != nil else {
                
                XCTAssert(true)
                return
            }
        } catch {
            XCTFail(error.localizedDescription)
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
            let testWorkout = try service.parseRow(row: sampleRow)
            XCTAssertEqual(testWorkout, sampleWorkout)
            
            // Test corrupted date
            let invalidDateRow = "No date,Barbell Bench Press,4,45"
            XCTAssertThrowsError(try service.parseRow(row: invalidDateRow)) { error in
                if let error = error as? WorkoutDataError {
                    XCTAssertEqual(error, WorkoutDataError.invalidDateFormat)
                }
            }
            
            // Test corrupted repetitions
            let invalidRepsRow = "Oct 05 2020,Barbell Bench Press,reps,45"
            XCTAssertThrowsError(try service.parseRow(row: invalidRepsRow)) { error in
                if let error = error as? WorkoutDataError {
                    XCTAssertEqual(error, WorkoutDataError.invalidRow)
                }
            }
            
            // Test corrupted weight
            let invalidWeightRow = "Oct 05 2020,Barbell Bench Press,4,weight"
            XCTAssertThrowsError(try service.parseRow(row: invalidWeightRow)) { error in
                if let error = error as? WorkoutDataError {
                    XCTAssertEqual(error, WorkoutDataError.invalidRow)
                }
            }
            
            // Test for empty row
            let emptyRow = ""
            XCTAssertThrowsError(try service.parseRow(row: emptyRow)) { error in
                if let error = error as? WorkoutDataError {
                    XCTAssertEqual(error, WorkoutDataError.invalidRow)
                }
            }
        } catch {
            XCTFail(error.localizedDescription)
        }
        
    }
    
    /// Tests the `serializeWorkoutDataFile` method.
    func testSerializeWorkoutDataFile() async {
        // Ensure the file exists at the passed URL
        guard let url = Bundle.main.url(forResource: WorkoutDataService.dataFileName,
                                             withExtension: WorkoutDataService.dataFileExtension),
              FileManager.default.fileExists(atPath: url.path) else {
            
            let message = String(localized: "WorkoutDataError.dataFileNotFound")
            XCTFail(message)
            return
        }
        
        var sampleWorkouts: [Workout] = []
        do {
            // Get file contents as a string
            guard let fileContent = try await service.loadWorkoutDataFile(atPath: url) else {
                throw WorkoutDataError.invalidDataFile
            }
            
            // Get workout rows and serialize them to a collection of Workout model objects
            let rows = fileContent.split(separator: "\n").map(String.init)
            sampleWorkouts = try rows.compactMap { try service.parseRow(row: $0) }
            XCTAssertFalse(sampleWorkouts.isEmpty)
            
            // Test service call
            let testWorkouts = try await service.serializeWorkoutDataFile(atPath: url)
            XCTAssertFalse(testWorkouts.isEmpty)
            XCTAssertEqual(testWorkouts, sampleWorkouts)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    override func tearDownWithError() throws {
        service = nil
    }
}

