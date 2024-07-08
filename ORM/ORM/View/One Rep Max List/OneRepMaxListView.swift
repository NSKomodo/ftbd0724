//
//  OneRepMaxListView.swift
//  ORM
//
//  Created by Jorge Tapia on 7/7/24.
//

import SwiftUI

/// View that will render the calculated one-rep max value for each exercice inside the data file.
struct OneRepMaxListView: View {
    
    @State var viewModel = ViewModel()
    
    var body: some View {
        if let errorMessage = viewModel.errorMessage {
            ErrorView(errorMessage: errorMessage)
        } else {
            NavigationStack {
                if !viewModel.oneRepMaxData.isEmpty {
                    List {
                        ForEach(viewModel.oneRepMaxData.sorted(by: <), id: \.key) { element in
                            NavigationLink(destination: WorkoutDetailView(viewModel: WorkoutDetailView.ViewModel(exercise: element.key,
                                                                                                                 oneRepMax: element.value,
                                                                                                                 workouts: viewModel.workouts))) {
                                OneRepMaxListItem(exercise: element.key, oneRepMax: element.value)
                            }
                            
                        }
                    }
                    .navigationTitle("One Rep Max")
                } else {
                    ContentUnavailableView("No Data",
                                           systemImage: "exclamationmark.octagon",
                                           description: Text("There's no workout data available."))
                }
            }
            .task {
                await viewModel.loadWorkoutDataFromFile()
            }
        }
    }
}

#Preview {
    OneRepMaxListView(viewModel: OneRepMaxListView.ViewModel())
}

