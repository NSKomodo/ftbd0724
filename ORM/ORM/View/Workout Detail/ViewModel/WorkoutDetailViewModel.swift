//
//  WorkoutDetailViewModel.swift
//  ORM
//
//  Created by Jorge Tapia on 7/8/24.
//

import Foundation

extension WorkoutDetailView {
    
    /// The view model that manages the state and interactions of `WorkoutDetailView`.
    @Observable
    class ViewModel {
        
        /// The exercise name that will be used to filter the workout data from the data file.
        var exercise: String = ""
        /// The overall one-rep max value.
        var oneRepMax: Double = 0.0
        /// The serialized workout data rows from the historical data file.
        var workouts: [Workout] = []
        /// The filtered workout data rows to plot a chart.
        var filteredData: [Workout] = []
        /// Error messages caught during data processing.
        var errorMessage: String?
        
        /// Data service instance.
        private let service: WorkoutDataService
        
        /// Initializes a view model instance using deoendency injection of the workout data service.
        /// - Parameters:
        ///   - exercise: The exercise that will be used to filter the `Workout` collection.
        ///   - oneRepMax: The overall one-rep max value for the given exercise.
        ///   - workouts: The serialized `Workout` object collection loaded rom the data file.
        ///   - service: A service object that conforms to the `WorkoutDataService` protocol.
        init(exercise: String, oneRepMax: Double, workouts: [Workout], service: WorkoutDataService = WorkoutDataFileService.shared) {
            self.exercise = exercise
            self.oneRepMax = oneRepMax
            self.workouts = workouts
            self.service = service
        }
        
        /// Loads serialized data from the provided historical workout data file.
        func loadFilteredWorkoutData() {
            filteredData = service.filterWorkouts(byExercise: exercise, from: workouts)
        }
    }
}
