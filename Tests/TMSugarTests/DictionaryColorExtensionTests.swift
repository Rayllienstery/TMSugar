//
//  DictionaryColorExtensionTests.swift
//  TMSugar
//
//  Created by Kostiantyn Kolosov on 24.03.2025.
//

import XCTest
import SwiftUI
@testable import TMSugar

class DictionaryColorExtensionTests: XCTestCase {
    
    // MARK: - Setup
    
    private enum TestConstants {
        static let accuracy: Double = 0.001
        static let defaultOpacity: Double = 1.0
        static let defaultRGBValue: Double = 0.0
        
        static let testColors: [(name: String, components: [String: Double])] = [
            ("Red", ["red": 1, "green": 0, "blue": 0, "opacity": 1]),
            ("Green", ["red": 0, "green": 1, "blue": 0, "opacity": 1]),
            ("Blue", ["red": 0, "green": 0, "blue": 1, "opacity": 1]),
            ("Custom", ["red": 0.5, "green": 0.3, "blue": 0.7, "opacity": 0.8])
        ]
    }
    
    // MARK: - Helper Methods
    
    /// Validates that created Color matches expected components
    /// - Parameters:
    ///   - color: Color to validate
    ///   - components: Expected color components
    private func validateColor(_ color: Color, against components: [String: Double]) {
        let resultingComponents = color.asDictionary
        
        components.forEach { key, expectedValue in
            XCTAssertEqual(resultingComponents[key]!, expectedValue, 
                         accuracy: TestConstants.accuracy,
                         "Component '\(key)' should match")
        }
    }
    
    /// Creates a dictionary with specified missing components
    /// - Parameters:
    ///   - components: Base components dictionary
    ///   - excluding: Keys to exclude
    /// - Returns: Dictionary with missing components
    private func createPartialDictionary(_ components: [String: Double], 
                                       excluding keys: [String]) -> [String: Double] {
        var partial = components
        keys.forEach { partial.removeValue(forKey: $0) }
        return partial
    }
    
    // MARK: - Basic Conversion Tests
    
    func testBasicColorConversion() {
        for testCase in TestConstants.testColors {
            let color = testCase.components.asColor
            validateColor(color, against: testCase.components)
        }
    }
    
    // MARK: - Missing Components Tests
    
    func testMissingRedComponent() {
        let components = ["green": 0.5, "blue": 0.7, "opacity": 1.0]
        let color = components.asColor
        
        let resultDict = color.asDictionary
        XCTAssertEqual(resultDict["red"], TestConstants.defaultRGBValue)
        XCTAssertEqual(resultDict["green"]!, 0.5, accuracy: TestConstants.accuracy)
        XCTAssertEqual(resultDict["blue"]!, 0.7, accuracy: TestConstants.accuracy)
        XCTAssertEqual(resultDict["opacity"]!, 1.0, accuracy: TestConstants.accuracy)
    }
    
    func testMissingGreenComponent() {
        let components = ["red": 0.5, "blue": 0.7, "opacity": 1.0]
        let color = components.asColor
        
        let resultDict = color.asDictionary
        XCTAssertEqual(resultDict["red"]!, 0.5, accuracy: TestConstants.accuracy)
        XCTAssertEqual(resultDict["green"]!, TestConstants.defaultRGBValue)
        XCTAssertEqual(resultDict["blue"]!, 0.7, accuracy: TestConstants.accuracy)
        XCTAssertEqual(resultDict["opacity"]!, 1.0, accuracy: TestConstants.accuracy)
    }
    
    func testMissingBlueComponent() {
        let components = ["red": 0.5, "green": 0.7, "opacity": 1.0]
        let color = components.asColor
        
        let resultDict = color.asDictionary
        XCTAssertEqual(resultDict["red"]!, 0.5, accuracy: TestConstants.accuracy)
        XCTAssertEqual(resultDict["green"]!, 0.7, accuracy: TestConstants.accuracy)
        XCTAssertEqual(resultDict["blue"]!, TestConstants.defaultRGBValue)
        XCTAssertEqual(resultDict["opacity"]!, 1.0, accuracy: TestConstants.accuracy)
    }
    
    func testMissingOpacityComponent() {
        let components = ["red": 0.5, "green": 0.7, "blue": 0.3]
        let color = components.asColor
        
        let resultDict = color.asDictionary
        XCTAssertEqual(resultDict["red"]!, 0.5, accuracy: TestConstants.accuracy)
        XCTAssertEqual(resultDict["green"]!, 0.7, accuracy: TestConstants.accuracy)
        XCTAssertEqual(resultDict["blue"]!, 0.3, accuracy: TestConstants.accuracy)
        XCTAssertEqual(resultDict["opacity"], TestConstants.defaultOpacity)
    }
    
    // MARK: - Edge Cases Tests
    
    func testEmptyDictionary() {
        let emptyDict: [String: Double] = [:]
        let color = emptyDict.asColor
        
        let resultDict = color.asDictionary
        XCTAssertEqual(resultDict["red"], TestConstants.defaultRGBValue)
        XCTAssertEqual(resultDict["green"], TestConstants.defaultRGBValue)
        XCTAssertEqual(resultDict["blue"], TestConstants.defaultRGBValue)
        XCTAssertEqual(resultDict["opacity"], TestConstants.defaultOpacity)
    }
    
    func testExtraComponents() {
        var components = TestConstants.testColors[0].components
        components["extra"] = 1.0
        
        let color = components.asColor
        validateColor(color, against: TestConstants.testColors[0].components)
    }
    
    // MARK: - Value Range Tests
    
    func testExtremumValues() {
        let testCases: [[String: Double]] = [
            ["red": 1, "green": 1, "blue": 1, "opacity": 1],  // White
            ["red": 0, "green": 0, "blue": 0, "opacity": 0],  // Transparent Black
            ["red": 0.999, "green": 0.001, "blue": 0.5, "opacity": 0.5]  // Custom
        ]
        
        for components in testCases {
            let color = components.asColor
            validateColor(color, against: components)
        }
    }
    
    // MARK: - Performance Tests
    
    func testConversionPerformance() {
        let components = TestConstants.testColors[0].components
        
        measure {
            for _ in 0..<1000 {
                _ = components.asColor
            }
        }
    }
}
