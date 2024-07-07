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
}

