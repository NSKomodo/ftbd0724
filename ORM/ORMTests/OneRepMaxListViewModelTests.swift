//
//  OneRepMaxListViewModelTests.swift
//  ORMTests
//
//  Created by Jorge Tapia on 7/8/24.
//

import XCTest
@testable import ORM

/// Class that tests the `OneRepMaxListView.ViewModel` code.
final class OneRepMaxListViewModelTests: XCTestCase {
    /// The view model.
    var viewModel: OneRepMaxListView.ViewModel!
    /// A mock `WorkoutDataService` service.
    var service: MockWorkoutDataService!
    
    @MainActor
    override func setUpWithError() throws {
        service = MockWorkoutDataService()
        viewModel = OneRepMaxListView.ViewModel(service: service)
    }
    
    /// Tests `loadWorkoutDataFromFile` method.
    @MainActor
    func testLoadWorkoutDataFromFile() async {
        await viewModel.loadWorkoutDataFromFile()
        
        XCTAssertEqual(viewModel.workouts.count, 6)
        XCTAssertEqual(viewModel.oneRepMaxData["Back Squat"] ?? 0, 275.625, accuracy: 0.01)
        XCTAssertEqual(viewModel.oneRepMaxData["Barbell Bench Press"] ?? 0, 161.3793103448276, accuracy: 0.01)
        XCTAssertEqual(viewModel.oneRepMaxData["Deadlift"] ?? 0, 167.58620689655172, accuracy: 0.01)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    /// Tests `loadWorkoutDataFromFile` method with failure condition.
    @MainActor
    func testLoadWorkoutFileFailure() async {
        service.shouldThrowError = true
        await viewModel.loadWorkoutDataFromFile()
        
        XCTAssertEqual(viewModel.workouts.count, 0)
        XCTAssertEqual(viewModel.oneRepMaxData.count, 0)
        XCTAssertNotNil(viewModel.errorMessage)
    }
    
    /// Tests `loadWorkoutDataFromFile` method with failure condition.
    @MainActor
    func testUpdateOneRepMaxData() async {
        service.shouldThrowError = false
        await viewModel.loadWorkoutDataFromFile()
        viewModel.updateOneRepMaxData()
        XCTAssertEqual(viewModel.oneRepMaxData.count, 3)
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        service = nil
    }
}

