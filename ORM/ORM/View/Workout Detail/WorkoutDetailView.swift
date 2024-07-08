//
//  WorkoutDetailView.swift
//  ORM
//
//  Created by Jorge Tapia on 7/8/24.
//

import SwiftUI
import Charts

/// Represents the view that will render the one-rep max data of a specific exercise and plot its historical data on a chart.
struct WorkoutDetailView: View {
    
    @State var viewModel: ViewModel
    @State private var scrollPosition = 0
    
    var body: some View {
        VStack {
            OneRepMaxListItem(exercise: viewModel.exercise,
                              oneRepMax: viewModel.oneRepMax)
            .padding()
            Chart {
                ForEach(viewModel.filteredData, id: \.self) { record in
                    LineMark(
                        x: .value("Date", record.date),
                        y: .value("1RM", record.oneRepMax)
                    )
                    .interpolationMethod(.catmullRom)
                    .symbol {
                        Circle()
                            .stroke(Color.blue, lineWidth: 2)
                            .fill(Color(UIColor.systemBackground))
                            .frame(width: 5, height: 5)
                    }
                }
            }
            .frame(height: 200)
            .padding()
            .chartScrollableAxes(.horizontal)
            Spacer()
        }
        .navigationTitle("Historical 1RM Data")
        .task {
            viewModel.loadFilteredWorkoutData()
        }
    }
}

#Preview {
    WorkoutDetailView(viewModel: WorkoutDetailView.ViewModel(exercise: "Back Squat",
                                                             oneRepMax: 275.625,
                                                             workouts: [Workout(date: DateHelper.parseWorkoutDate(from: "Nov 22 2019")!, exercise: "Back Squat", repetitions: 5, weight: 245),
                                                                        Workout(date: DateHelper.parseWorkoutDate(from: "Nov 22 2019")!, exercise: "Back Squat", repetitions: 5, weight: 245),
                                                                        Workout(date: DateHelper.parseWorkoutDate(from: "Nov 20 2019")!, exercise: "Deadlift", repetitions: 10, weight: 45),
                                                                        Workout(date: DateHelper.parseWorkoutDate(from: "Nov 20 2019")!, exercise: "Deadlift", repetitions: 8, weight: 135),
                                                                        Workout(date: DateHelper.parseWorkoutDate(from: "Nov 15 2019")!, exercise: "Barbell Bench Press", repetitions: 10, weight: 45),
                                                                        Workout(date: DateHelper.parseWorkoutDate(from: "Nov 15 2019")!, exercise: "Barbell Bench Press", repetitions: 8, weight: 130)]))
}
