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
    
    /// Tests `loadDataFile`.
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

    override func tearDownWithError() throws {
        service = nil
    }
}

