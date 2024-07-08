//
//  ColorHelper.swift
//  ORM
//
//  Created by Jorge Tapia on 7/8/24.
//

import SwiftUI

extension Color {
    
    /// Initializes a `Color` instance from a `UIColor` one.
    /// - Parameter uiColor: The `UIColor` that needs to be converted to `Color`.
    init(_ uiColor: UIColor) {
        self.init(uiColor.cgColor)
    }
}

