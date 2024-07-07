//
//  WorkoutDataError.swift
//  ORM
//
//  Created by Jorge Tapia on 7/7/24.
//

import Foundation

/// Represents an error that could occur when processing workout data.
enum WorkoutDataError: Error {
    /// Thrown when the data file is missing or corrupted.
    case dataFile
    /// Thrown if a workout record row does not have the expected structure or is invalid.
    case invalidRow
    /// Thrown if the date format is not valid.
    case invalidDateFormat
}

