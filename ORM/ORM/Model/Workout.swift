//
//  Workout.swift
//  ORM
//
//  Created by Jorge Tapia on 7/7/24.
//

import Foundation

/// Represents a workout row inside the historical data file.
struct Workout: Equatable, Codable {
    /// The date the workout was completed.
    let date: Date
    /// The name of exercise.
    let exercise: String
    /// The number of repetitions.
    let repetitions: Int
    /// The weight used during the exercise.
    let weight: Double
}

