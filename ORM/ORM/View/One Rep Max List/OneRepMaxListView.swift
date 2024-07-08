//
//  OneRepMaxListView.swift
//  ORM
//
//  Created by Jorge Tapia on 7/7/24.
//

import SwiftUI

/// View that will render the calculated One-Rep Max value for each exercice inside the data file.
struct OneRepMaxListView: View {
    struct Dummy1RM: Identifiable {
        var id = UUID()
        let exercise = "Barbell Bench Press"
        let oneRepMaxLbs = "One-Rep Max • lbs"
        let weight = "315"
    }
    
    let dummyData: [Dummy1RM] = [Dummy1RM(), Dummy1RM(), Dummy1RM()]
    
    var body: some View {
        NavigationStack {
            if !dummyData.isEmpty {
                List {
                    ForEach(dummyData) { datum in
                        VStack {
                            HStack {
                                Text(datum.exercise)
                                    .font(.title2)
                                Spacer()
                                Text(datum.weight)
                                    .font(.title2)
                            }
                            HStack {
                                Text(datum.oneRepMaxLbs)
                                    .font(.footnote)
                                Spacer()
                            }
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
    }
}

#Preview {
    OneRepMaxListView()
}

