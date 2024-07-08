//
//  OneRepMaxListViewModel.swift
//  ORM
//
//  Created by Jorge Tapia on 7/8/24.
//

import Foundation

extension OneRepMaxListView {
    
    /// The view model that manages the state and interactions of `OneRepMaxListView`.
    @Observable
    class ViewModel {
        
        /// The serialized workout data rows from the historical data file.
        var workouts: [Workout] = []
        /// The calculated one-rep max per exercise.
        var oneRepMaxData: [String: Double] = [:]
        /// Error messages caught during data processing.
        var errorMessage: String?
        
        /// Data service instance.
        private let service: WorkoutDataService
        
        /// Initializes a view model instance using deoendency injection of the workout data service.
        /// - Parameter service: A service object that conforms to the `WorkoutDataService` protocol.
        init(service: WorkoutDataService = WorkoutDataFileService.shared) {
            self.service = service
        }
        
        /// Loads serialized data from the provided historical workout data file.
        func loadWorkoutDataFromFile() async {
            // Ensure the file exists
            guard let url = Bundle.main.url(forResource: WorkoutDataFileService.dataFileName,
                                                 withExtension: WorkoutDataFileService.dataFileExtension),
                  FileManager.default.fileExists(atPath: url.path) else {
                
                errorMessage = String(localized: "WorkoutDataError.dataFileNotFound")
                return
            }
            
            do {
                let workouts = try await service.serializeWorkoutDataFile(atPath: url)
                self.workouts = workouts
                self.oneRepMaxData = service.calculateOverallOneRepMaxPerExercise(from: workouts)
            } catch {
                guard let error = error as? WorkoutDataError else {
                    errorMessage = error.localizedDescription
                    return
                }
                
                switch error {
                case .dataFileNotFound:
                    errorMessage = String(localized: "WorkoutDataError.dataFileNotFound")
                case .invalidDataFile:
                    errorMessage = String(localized: "WorkoutDataError.invalidDataFile")
                case .invalidDateFormat:
                    errorMessage = String(localized: "WorkoutDataError.invalidDateFormat")
                case .invalidRow:
                    errorMessage = String(localized: "WorkoutDataError.invalidRow")
                }
            }
        }
        
        /// Updates  the overall one-rep max view model data.
        func updateOneRepMaxData() {
            oneRepMaxData = service.calculateOverallOneRepMaxPerExercise(from: workouts)
        }
    }
}

