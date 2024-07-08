//
//  WorkoutDataService.swift
//  ORM
//
//  Created by Jorge Tapia on 7/8/24.
//

import Foundation

protocol WorkoutDataService {
    /// Parses a workout row from the historical data file.
    /// - Parameters:
    ///   - row: The workout row to be parsed.
    /// - Returns: A serialized `Workout` model for the row.
    func parseRow(row: String) throws -> Workout?
    
    /// Loads the historical workout data file asynchronously.
    /// - Parameter url: The file path `URL`.
    /// - Returns: The contents of the data file as a `String`.
    func loadWorkoutDataFile(atPath url: URL) async throws -> String?
    
    /// Serializes the contents of the historical workout data file into a collection of `Workout` models.
    /// - Returns: An array of serialized `Workout` objects.
    func serializeWorkoutDataFile(atPath url: URL) async throws -> [Workout]
    
    /// Calculates the overall one-rep max per exercise.
    /// - Parameter workouts: The `Workout` collection to calculate from.
    /// - Returns: The calculated overall one-rep max per excercise.
    func calculateOverallOneRepMaxPerExercise(from workouts: [Workout]) -> [String: Double]
}

