//
//  ColorHelperTests.swift
//  ORMTests
//
//  Created by Jorge Tapia on 7/8/24.
//

import XCTest
import SwiftUI
@testable import ORM

/// Class that tests the `ColorHelper` code.
final class ColorHelperTests: XCTestCase {
    func testColorInitializationFromUIColor() {
        let uiColor = UIColor(red: 0.25, green: 0.5, blue: 0.75, alpha: 1.0)
        let color = Color(uiColor)
        
        // Extract the components of the Color instance
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        // Convert Color to UIColor to extract the components
        UIColor(color).getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        // Assert that the components match the original UIColor components
        XCTAssertEqual(red, 0.25, accuracy: 0.01)
        XCTAssertEqual(green, 0.5, accuracy: 0.01)
        XCTAssertEqual(blue, 0.75, accuracy: 0.01)
        XCTAssertEqual(alpha, 1.0, accuracy: 0.01)
    }
}
