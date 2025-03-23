//
//  DataExtensionsTests.swift
//  TMSugar
//
//  Created by Kostiantyn Kolosov on 23.03.2025.
//

import XCTest
import SwiftUI
@testable import TMSugar

final class DataTests: XCTestCase {
    
    // MARK: - Test Constants
    
    private enum TestConstants {
        static let basicString = "Hello, World!"
        static let unicodeString = "Hello, 世界! 🌍"
        static let systemImageNames = [
            "scribble.variable",
            "square.fill",
            "circle.fill",
            "star.fill"
        ]
        static let imageSize = CGSize(width: 100, height: 100)
    }
    
    // MARK: - Test Data
    
    /// Creates sample image data using SF Symbols
    private var sampleImageData: Data {
        guard let imageData = UIImage(systemName: TestConstants.systemImageNames[0])?.pngData() else {
            fatalError("Failed to create test image data")
        }
        return imageData
    }
    
    /// Creates a colored test image
    private var coloredImageData: Data {
        UIGraphicsBeginImageContext(TestConstants.imageSize)
        defer { UIGraphicsEndImageContext() }
        
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor.red.cgColor)
        context?.fill(CGRect(origin: .zero, size: TestConstants.imageSize))
        
        guard let image = UIGraphicsGetImageFromCurrentImageContext(),
              let imageData = image.pngData() else {
            fatalError("Failed to create colored test image data")
        }
        return imageData
    }
    
    /// Sample string data for testing string conversion
    private var sampleStringData: Data {
        guard let data = TestConstants.basicString.data(using: .utf8) else {
            fatalError("Failed to create sample string data")
        }
        return data
    }
    
    /// Sample Unicode string data
    private var unicodeStringData: Data {
        guard let data = TestConstants.unicodeString.data(using: .utf8) else {
            fatalError("Failed to create Unicode string data")
        }
        return data
    }
    
    /// Invalid data for negative testing
    private let invalidData = Data([0xFF, 0xFF, 0xFF, 0xFF])
    
    /// Empty data for edge case testing
    private let emptyData = Data()
    
    // MARK: - Functional Tests
    
    func testAsUIImage_WithValidSFSymbolData_ShouldReturnUIImage() {
        // Given valid SF Symbol image data
        let data = sampleImageData
        
        // When converting to UIImage
        let result = data.asUIImage
        
        // Then should return valid UIImage
        XCTAssertNotNil(result)
        XCTAssertTrue(result != nil)
        XCTAssertGreaterThan(result?.size.width ?? 0, 0)
        XCTAssertGreaterThan(result?.size.height ?? 0, 0)
    }
    
    func testAsUIImage_WithColoredImageData_ShouldReturnUIImage() {
        // Given valid colored image data
        let data = coloredImageData
        
        // When converting to UIImage
        let result = data.asUIImage
        
        // Then should return valid UIImage with correct dimensions
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.size.width, TestConstants.imageSize.width)
        XCTAssertEqual(result?.size.height, TestConstants.imageSize.height)
    }
    
    func testAsUIImage_WithInvalidData_ShouldReturnNil() {
        // Given invalid image data
        let data = invalidData
        
        // When converting to UIImage
        let result = data.asUIImage
        
        // Then should return nil
        XCTAssertNil(result)
    }
    
    func testAsUIImage_WithEmptyData_ShouldReturnNil() {
        // Given empty data
        let data = emptyData
        
        // When converting to UIImage
        let result = data.asUIImage
        
        // Then should return nil
        XCTAssertNil(result)
    }
    
    // MARK: - asImage Tests
    
    func testAsImage_WithValidSFSymbolData_ShouldReturnSwiftUIImage() {
        // Given valid SF Symbol image data
        let data = sampleImageData
        
        // When converting to SwiftUI Image
        let result = data.asImage
        
        // Then should return valid SwiftUI Image
        XCTAssertNotNil(result)
        XCTAssertTrue(result != nil)
    }
    
    func testAsImage_WithColoredImageData_ShouldReturnSwiftUIImage() {
        // Given valid colored image data
        let data = coloredImageData
        
        // When converting to SwiftUI Image
        let result = data.asImage
        
        // Then should return valid SwiftUI Image
        XCTAssertNotNil(result)
        XCTAssertTrue(result != nil)
    }
    
    func testAsImage_WithInvalidData_ShouldReturnNil() {
        // Given invalid image data
        let data = invalidData
        
        // When converting to SwiftUI Image
        let result = data.asImage
        
        // Then should return nil
        XCTAssertNil(result)
    }
    
    func testAsImage_WithEmptyData_ShouldReturnNil() {
        // Given empty data
        let data = emptyData
        
        // When converting to SwiftUI Image
        let result = data.asImage
        
        // Then should return nil
        XCTAssertNil(result)
    }
    
    // MARK: - asString Tests
    
    func testAsString_WithValidUTF8Data_ShouldReturnString() {
        // Given valid UTF-8 string data
        let data = sampleStringData
        
        // When converting to String
        let result = data.asString
        
        // Then should return correct string
        XCTAssertNotNil(result)
        XCTAssertEqual(result, TestConstants.basicString)
    }
    
    func testAsString_WithUnicodeData_ShouldReturnString() {
        // Given valid Unicode string data
        let data = unicodeStringData
        
        // When converting to String
        let result = data.asString
        
        // Then should return correct Unicode string
        XCTAssertNotNil(result)
        XCTAssertEqual(result, TestConstants.unicodeString)
    }
    
    func testAsString_WithInvalidUTF8Data_ShouldReturnNil() {
        // Given invalid UTF-8 data
        let data = invalidData
        
        // When converting to String
        let result = data.asString
        
        // Then should return nil
        XCTAssertNil(result)
    }
    
    func testAsString_WithEmptyData_ShouldReturnEmptyString() {
        // Given empty data
        let data = emptyData
        
        // When converting to String
        let result = data.asString
        
        // Then should return empty string
        XCTAssertNotNil(result)
        XCTAssertEqual(result, "")
    }
}
