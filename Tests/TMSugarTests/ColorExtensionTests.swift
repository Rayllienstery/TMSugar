//
//  ColorExtensionTests.swift
//  TMSugar
//
//  Created by Kostiantyn Kolosov on 24.03.2025.
//

import XCTest
import SwiftUI
@testable import TMSugar

class ColorExtensionTests: XCTestCase {
    
    // MARK: - Setup
    
    /// Constants for testing
    private enum TestConstants {
        static let accuracy: Double = 0.001
        static let requiredKeys = ["red", "green", "blue", "opacity"]
    }
    
    // MARK: - Helper Methods
    
    /// Validates that dictionary contains all required color components
    /// - Parameter dict: Dictionary to validate
    private func validateDictionaryStructure(_ dict: [String: Double]) {
        TestConstants.requiredKeys.forEach { key in
            XCTAssertNotNil(dict[key], "Dictionary should contain '\(key)' key")
        }
        XCTAssertEqual(dict.keys.count, TestConstants.requiredKeys.count, "Dictionary should contain exactly 4 keys")
    }
    
    /// Validates that all color values are within valid range [0...1]
    /// - Parameter dict: Dictionary to validate
    private func validateColorValueRanges(_ dict: [String: Double]) {
        dict.forEach { (key, value) in
            XCTAssertGreaterThanOrEqual(value, 0.0, "'\(key)' should be >= 0")
            XCTAssertLessThanOrEqual(value, 1.0, "'\(key)' should be <= 1")
        }
    }
    
    /// Validates color components against expected values
    /// - Parameters:
    ///   - dict: Dictionary to validate
    ///   - red: Expected red value
    ///   - green: Expected green value
    ///   - blue: Expected blue value
    ///   - opacity: Expected opacity value
    private func validateColorComponents(
        _ dict: [String: Double],
        red: Double,
        green: Double,
        blue: Double,
        opacity: Double
    ) {
        XCTAssertEqual(dict["red"]!, red, accuracy: TestConstants.accuracy)
        XCTAssertEqual(dict["green"]!, green, accuracy: TestConstants.accuracy)
        XCTAssertEqual(dict["blue"]!, blue, accuracy: TestConstants.accuracy)
        XCTAssertEqual(dict["opacity"]!, opacity, accuracy: TestConstants.accuracy)
    }
    
    // MARK: - Basic Colors Tests
    
    func testPrimaryColors() {
        // Test cases for primary colors
        let testCases: [(color: Color, name: String, components: (r: Double, g: Double, b: Double, o: Double))] = [
            (Color.red, "red", (1, 0, 0, 1)),
            (Color.green, "green", (0, 1, 0, 1)),
            (Color.blue, "blue", (0, 0, 1, 1))
        ]
        
        for testCase in testCases {
            let dict = testCase.color.asDictionary
            validateDictionaryStructure(dict)
            validateColorValueRanges(dict)
            validateColorComponents(dict,
                                 red: testCase.components.r,
                                 green: testCase.components.g,
                                 blue: testCase.components.b,
                                 opacity: testCase.components.o)
        }
    }
    
    // MARK: - Transparency Tests
    
    func testTransparencyVariations() {
        // Test fully transparent
        let clearColor = Color.clear.asDictionary
        validateColorComponents(clearColor, red: 0, green: 0, blue: 0, opacity: 0)
        
        // Test semi-transparent
        let semiTransparentValues: [Double] = [0.25, 0.5, 0.75]
        
        for opacity in semiTransparentValues {
            let color = Color(.sRGB, red: 1, green: 0, blue: 0, opacity: opacity)
            let dict = color.asDictionary
            validateColorComponents(dict, red: 1, green: 0, blue: 0, opacity: opacity)
        }
    }
    
    // MARK: - Custom Color Tests
    
    func testCustomColorValues() {
        let testCases: [(r: Double, g: Double, b: Double, o: Double)] = [
            (0.5, 0.5, 0.5, 1.0),  // Gray
            (0.8, 0.2, 0.3, 0.7),  // Custom red-ish
            (0.2, 0.8, 0.3, 0.9),  // Custom green-ish
            (0.3, 0.2, 0.8, 0.8)   // Custom blue-ish
        ]
        
        for components in testCases {
            let color = Color(.sRGB,
                            red: components.r,
                            green: components.g,
                            blue: components.b,
                            opacity: components.o)
            let dict = color.asDictionary
            
            validateDictionaryStructure(dict)
            validateColorValueRanges(dict)
            validateColorComponents(dict,
                                 red: components.r,
                                 green: components.g,
                                 blue: components.b,
                                 opacity: components.o)
        }
    }
    
    // MARK: - Edge Cases
    
    func testEdgeCases() {
        // Test white
        let whiteColor = Color.white.asDictionary
        validateColorComponents(whiteColor, red: 1, green: 1, blue: 1, opacity: 1)
        
        // Test black
        let blackColor = Color.black.asDictionary
        validateColorComponents(blackColor, red: 0, green: 0, blue: 0, opacity: 1)
    }
    
    // MARK: - Performance Test
    
    func testColorConversionPerformance() {
        let color = Color.red
        measure {
            for _ in 0..<1000 {
                _ = color.asDictionary
            }
        }
    }
}
