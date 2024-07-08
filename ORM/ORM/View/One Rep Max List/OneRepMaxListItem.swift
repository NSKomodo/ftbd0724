//
//  OneRepMaxListItem.swift
//  ORM
//
//  Created by Jorge Tapia on 7/8/24.
//

import SwiftUI

/// Represents a list item view that renders a workout exercise and its overall one-rep max value.
struct OneRepMaxListItem: View {
    
    /// The exercise name.
    let exercise: String
    /// The overall one-rep max value.
    let oneRepMax: Double
    
    var body: some View {
        VStack {
            HStack {
                Text(exercise)
                    .font(.title2)
                Spacer()
                Text(String(format: "%.0f", oneRepMax))
                    .font(.title2)
            }
            HStack {
                Text("One Rep Max • lbs")
                    .font(.footnote)
                Spacer()
            }
        }
    }
}
    
