//
//  WorkoutDataService.swift
//  ORM
//
//  Created by Jorge Tapia on 7/7/24.
//

import UIKit

/// Service that parses and processes a historical workout data file.
/// Each workout record is a comma separted string per line using.
class WorkoutDataService {
    
    /// The historical workout data file extension.
    static let dataFileName = "workoutData"
    /// The historical workout data file extension.
    static let dataFileExtension = "txt"
    
    /// The shared singleton service object.
    static let shared = WorkoutDataService()
    
    /// Default initializer.
    private init() {}
    
    /// Parses a workout row from the historical data file.
    /// - Parameters:
    ///   - row: The workout row to be parsed.
    /// - Returns: A serialized `Workout` model for the row.
    func parseRow(row: String) throws -> Workout? {
        let fields = row.split(separator: ",")
        if fields.count != 4 {
            throw WorkoutDataError.invalidRow
        }
        
        // Extract fields from row and covert them from String.Subsequence to String
        let dateField = String(fields[0])
        let exerciseField = String(fields[1])
        let repsField = String(fields[2])
        let weightField = String(fields[3])
        
        // Attempt to parse date field
        guard let date = DateHelper.parseWorkoutDate(from: dateField) else {
            throw WorkoutDataError.invalidDateFormat
        }
        
        // Attempt to cast fields to expected types
        guard let reps = Int(repsField),
              let weight = Double(weightField) else {
            
            throw WorkoutDataError.invalidRow
        }
        
        return Workout(date: date,
                       exercise: exerciseField,
                       repetitions: reps,
                       weight: weight)
    }
    
    /// Loads the historical workout data file asynchronously.
    /// - Parameter url: The file path `URL`.
    /// - Returns: The contents of the data file as a `String`.
    func loadWorkoutDataFile(atPath url: URL) async throws -> String? {
        // Ensure the file exists at the passed URL
        guard FileManager.default.fileExists(atPath: url.path) else {
            throw WorkoutDataError.dataFileNotFound
        }
        
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
        
        return String(data: data, encoding: .utf8)
    }
    
    /// Serializes the contents of the historical workout data file into a collection of `Workout` models.
    /// - Returns: An array of serialized `Workout` objects.
    func serializeWorkoutDataFile(atPath url: URL) async throws -> [Workout] {
        var workouts: [Workout] = []
        
        // Get workout rows and serialize them to a collection of Workout model objects
        do {
            // Get file contents as a string
            guard let fileContent = try await loadWorkoutDataFile(atPath: url) else {
                throw WorkoutDataError.invalidDataFile
            }
            let rows = fileContent.split(separator: "\n").map(String.init)
            workouts =  try rows.compactMap { try parseRow(row: $0) }
        } catch WorkoutDataError.invalidDataFile {
            throw WorkoutDataError.invalidDataFile
        }  catch WorkoutDataError.invalidDateFormat {
            throw WorkoutDataError.invalidDateFormat
        } catch WorkoutDataError.invalidRow {
            throw WorkoutDataError.invalidRow
        }
        
        return workouts
    }
}

