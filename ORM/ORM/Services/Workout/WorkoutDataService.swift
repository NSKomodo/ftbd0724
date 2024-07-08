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
    /// The shared singleton service object.
    static let shared = WorkoutDataService()
    
    /// Data asset representation of the historical workout data file to be processed.
    private(set) var dataFileAsset: NSDataAsset?
    
    /// Determines if the historical workout data file is loaded.
    var dataFileIsLoaded: Bool {
        dataFileAsset != nil
    }
    
    /// Default initializer.
    private init() {}
    
    /// Attempts to load historical workout data file from app's asset catalog.
    /// - Thows: `WorkoutDataError.dataFile` error if the file is not present in the asset catalog.
    func loadDataFile() throws {
        if !dataFileIsLoaded {
            dataFileAsset = NSDataAsset(name: "workoutData")
            if dataFileAsset == nil {
                throw WorkoutDataError.dataFile
            }
        }
    }
    
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
    
    /// Serializes the contents of the historical workout data file into a collection of `Workout` models.
    /// - Returns: An array of serialized `Workout` objects.
    func serializeWorkoutDataFile() throws -> [Workout] {
        // Check if data file has been loaded from assest catalog
        if !dataFileIsLoaded {
            throw WorkoutDataError.dataFile
        }
        
        // Get file contents as a string
        guard let fileData = dataFileAsset?.data,
              let fileContent = String(data: fileData, encoding: .utf8) else {
            
            throw WorkoutDataError.dataFile
        }
        
        var workouts: [Workout] = []
        
        // Get workout rows and serialize them to a collection of Workout model objects
        do {
            let rows = fileContent.split(separator: "\n").map(String.init)
            workouts =  try rows.compactMap { try parseRow(row: $0) }
        } catch WorkoutDataError.dataFile {
            throw WorkoutDataError.dataFile
        }  catch WorkoutDataError.invalidDateFormat {
            throw WorkoutDataError.invalidDateFormat
        } catch WorkoutDataError.invalidRow {
            throw WorkoutDataError.invalidRow
        }
        
        return workouts
    }
}

