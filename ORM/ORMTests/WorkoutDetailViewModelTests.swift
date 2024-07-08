//
//  WorkoutDetailViewModelTests.swift
//  ORMTests
//
//  Created by Jorge Tapia on 7/8/24.
//

import XCTest
@testable import ORM

/// Class that tests the `WorkoutDetailView.ViewModel` code.
final class WorkoutDetailViewModelTests: XCTestCase {
    /// The view model.
    var viewModel: WorkoutDetailView.ViewModel!
    /// A mock `WorkoutDataService` service.
    var service: MockWorkoutDataService!
    /// Sample workout collection.
    let sampleWorkouts = [Workout(date: DateHelper.parseWorkoutDate(from: "Nov 22 2019")!, exercise: "Back Squat", repetitions: 5, weight: 245),
                    Workout(date: DateHelper.parseWorkoutDate(from: "Nov 22 2019")!, exercise: "Back Squat", repetitions: 5, weight: 245),
                    Workout(date: DateHelper.parseWorkoutDate(from: "Nov 20 2019")!, exercise: "Deadlift", repetitions: 10, weight: 45),
                    Workout(date: DateHelper.parseWorkoutDate(from: "Nov 20 2019")!, exercise: "Deadlift", repetitions: 8, weight: 135),
                    Workout(date: DateHelper.parseWorkoutDate(from: "Nov 15 2019")!, exercise: "Barbell Bench Press", repetitions: 10, weight: 45),
                    Workout(date: DateHelper.parseWorkoutDate(from: "Nov 15 2019")!, exercise: "Barbell Bench Press", repetitions: 8, weight: 130)]
    
    @MainActor
    override func setUpWithError() throws {
        service = MockWorkoutDataService()
        viewModel = WorkoutDetailView.ViewModel(exercise: "Back Squat",
                                                oneRepMax: 275.625,
                                                workouts: sampleWorkouts,
                                                service: service)
    }
    
    /// Tests `loadFilteredWorkoutData` method.
    func testLoadFilteredWorkoutData() {
        let sampleFilteredData = sampleWorkouts.filter { $0.exercise.lowercased() == viewModel.exercise.lowercased() }
        viewModel.loadFilteredWorkoutData()
        XCTAssertEqual(viewModel.filteredData, sampleFilteredData)
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        service = nil
    }
}

