//
//  Workout.swift
//  ORM
//
//  Created by Jorge Tapia on 7/7/24.
//

import Foundation

/// Represents a workout row inside the historical data file.
struct Workout: Equatable, Hashable, Codable {
    /// The date the workout was completed.
    let date: Date
    /// The name of exercise.
    let exercise: String
    /// The number of repetitions.
    let repetitions: Int
    /// The weight used during the exercise.
    let weight: Double
}

// MARK: - One Rep Max Calculation

extension Workout {
    /// Calculates the One-Rep Max of a workout based on the Brzycki formula.
    /// - SeeAlso: [One-repetition maximum on Wikpedia](https://en.wikipedia.org/wiki/One-repetition_maximum)
    /// - Returns: The estimated 1RM value for the workout.
    var oneRepMax: Double {
        weight * (36 / Double(37 - repetitions))
    }
}

