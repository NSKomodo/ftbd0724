//
//  ErrorView.swift
//  ORM
//
//  Created by Jorge Tapia on 7/8/24.
//

import SwiftUI

/// Represents a view that will render when an error occurs.
struct ErrorView: View {
    /// The error message to display.
    let errorMessage: String
    
    var body: some View {
        ContentUnavailableView("Oops!",
                               systemImage: "hand.thumbsdown",
                               description: Text(errorMessage))
    }
}

