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
                XCTFail("Could not load workoutData.txt file from asset catalog")
            }
        }
        
        do {
            try service?.loadDataFile()
            XCTAssertEqual(service?.dataFileAsset, dataFileAsset)
            dataFileAsset = nil
        } catch WorkoutDataError.dataFile {
            XCTFail("Could not load workoutData.txt file from asset catalog using the service instance.")
        } catch {
            XCTFail("Unexpected error while attempting to load workoutData.txt file from asset catalog using the service instance.")
        }
    }

    override func tearDownWithError() throws {
        service = nil
    }
}

