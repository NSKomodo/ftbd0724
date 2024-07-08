//
//  MockWorkoutDataService.swift
//  ORMTests
//
//  Created by Jorge Tapia on 7/8/24.
//

import Foundation
@testable import ORM

/// Mock `WorkoutDataService` implementation for testing purposes.
final class MockWorkoutDataService: WorkoutDataService {
    /// Flag that determines if an error should be thrown.
    var shouldThrowError = false
    
    /// Mock `parseRow` method.
    func parseRow(row: String) throws -> Workout? {
        if shouldThrowError {
            throw WorkoutDataError.invalidRow
        }
        return Workout(date: DateHelper.parseWorkoutDate(from: "Oct 05 2020")!,
                       exercise: "Barbell Bench Press",
                       repetitions: 4,
                       weight: 45)
    }
    
    /// Mock `loadWorkoutDataFile` method.
    func loadWorkoutDataFile(atPath url: URL) async throws -> String? {
        if shouldThrowError {
            throw WorkoutDataError.dataFileNotFound
        }
        return """
        Nov 22 2019,Back Squat,6,245
        Nov 22 2019,Back Squat,6,245
        Nov 20,Deadlift,10,45
        Nov 20,Deadlift,8,135
        Nov 15 2019,Barbell Bench Press,10,45
        Nov 15 2019,Barbell Bench Press,8,130
        """
    }
    
    /// Mock `serializeWorkoutDataFile` method.
    func serializeWorkoutDataFile(atPath url: URL) async throws -> [Workout] {
        if shouldThrowError {
            throw WorkoutDataError.invalidDataFile
        }
        return [Workout(date: DateHelper.parseWorkoutDate(from: "Nov 22 2019")!, exercise: "Back Squat", repetitions: 6, weight: 245),
                Workout(date: DateHelper.parseWorkoutDate(from: "Nov 22 2019")!, exercise: "Back Squat", repetitions: 6, weight: 245),
                Workout(date: DateHelper.parseWorkoutDate(from: "Nov 20 2019")!, exercise: "Deadlift", repetitions: 10, weight: 45),
                Workout(date: DateHelper.parseWorkoutDate(from: "Nov 20 2019")!, exercise: "Deadlift", repetitions: 8, weight: 135),
                Workout(date: DateHelper.parseWorkoutDate(from: "Nov 15 2019")!, exercise: "Barbell Bench Press", repetitions: 10, weight: 45),
                Workout(date: DateHelper.parseWorkoutDate(from: "Nov 15 2019")!, exercise: "Barbell Bench Press", repetitions: 8, weight: 130)]
    }
    
    /// Mock `calculateOverallOneRepMaxPerExercise` method.
    func calculateOverallOneRepMaxPerExercise(from workouts: [Workout]) -> [String : Double] {
        ["Back Squat": 275.625,
         "Barbell Bench Press": 161.3793103448276,
         "Deadlift": 167.58620689655172]
    }
    
    /// Mock `calculateOverallOneRepMaxPerExercise` method.
    func filterWorkouts(byExercise exercise: String, from workouts: [Workout]) -> [Workout] {
        [Workout(date: DateHelper.parseWorkoutDate(from: "Nov 22 2019")!, exercise: "Back Squat", repetitions: 5, weight: 245),
         Workout(date: DateHelper.parseWorkoutDate(from: "Nov 22 2019")!, exercise: "Back Squat", repetitions: 5, weight: 245)]
    }
}

