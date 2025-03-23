//
//  StringTests.swift
//  TMSugar
//
//  Created by Kostiantyn Kolosov on 23.03.2025.
//

import XCTest

final class StringTests: XCTestCase {
    
    // MARK: - Test Data
    
    /// Constants used across multiple tests
    private enum TestConstants {
        static let validURL = "https://www.example.com"
        static let validURLWithPath = "https://www.example.com/path"
        static let validURLWithQuery = "https://www.example.com?param=value"
        static let validURLWithPort = "https://www.example.com:8080"
        static let invalidURL = "invalid_url_string"
        static let urlWithSpaces = "https://www.example.com/test path"
        static let encodedURLWithSpaces = "https://www.example.com/test%20path"
        
        static let basicString = "Hello, World!"
        static let unicodeString = "Hello, 世界! 🌍"
        static let specialCharacters = "!@#$%^&*()_+"
        static let multilineString = """
        Line 1
        Line 2
        Line 3
        """
    }
    
    // MARK: - asURL Tests
    
    func testAsURL_WithValidURL_ShouldReturnURL() {
        // Given a valid URL string
        let validURLString = TestConstants.validURL
        
        // When converting to URL
        let url = validURLString.asURL
        
        // Then should return valid URL
        XCTAssertNotNil(url, "Should create valid URL")
        XCTAssertEqual(url?.absoluteString, validURLString, "URL string should match original")
    }
    
    func testAsURL_WithValidURLAndPath_ShouldReturnURL() {
        // Given a valid URL string with path
        let urlString = TestConstants.validURLWithPath
        
        // When converting to URL
        let url = urlString.asURL
        
        // Then should return valid URL with path
        XCTAssertNotNil(url)
        XCTAssertEqual(url?.path, "/path")
    }
    
    func testAsURL_WithValidURLAndQuery_ShouldReturnURL() {
        // Given a valid URL string with query parameters
        let urlString = TestConstants.validURLWithQuery
        
        // When converting to URL
        let url = urlString.asURL
        
        // Then should return valid URL with query
        XCTAssertNotNil(url)
        XCTAssertEqual(url?.query, "param=value")
    }
    
    func testAsURL_WithValidURLAndPort_ShouldReturnURL() {
        // Given a valid URL string with port
        let urlString = TestConstants.validURLWithPort
        
        // When converting to URL
        let url = urlString.asURL
        
        // Then should return valid URL with port
        XCTAssertNotNil(url)
        XCTAssertEqual(url?.port, 8080)
    }
    
    func testAsURL_WithInvalidURL_ShouldReturnNil() {
        // Given an invalid URL string
        let invalidURLString = TestConstants.invalidURL
        
        // When converting to URL
        let url = invalidURLString.asURL
        
        // Then should return nil
        XCTAssertNil(url, "Invalid URL should return nil")
    }
    
    func testAsURL_WithEmptyString_ShouldReturnNil() {
        // Given an empty string
        let emptyString = ""
        
        // When converting to URL
        let url = emptyString.asURL
        
        // Then should return nil
        XCTAssertNil(url, "Empty string should return nil")
    }
    
    func testAsURL_WithSpaces_ShouldReturnNil() {
        // Given a URL string with unencoded spaces
        let urlWithSpaces = TestConstants.urlWithSpaces
        
        // When converting to URL
        let url = urlWithSpaces.asURL
        
        // Then should return nil
        XCTAssertNil(url, "URL with unencoded spaces should return nil")
    }
    
    func testAsURL_WithEncodedSpaces_ShouldReturnURL() {
        // Given a URL string with encoded spaces
        let encodedURLString = TestConstants.encodedURLWithSpaces
        
        // When converting to URL
        let url = encodedURLString.asURL
        
        // Then should return valid URL
        XCTAssertNotNil(url, "URL with encoded spaces should be valid")
        XCTAssertEqual(url?.absoluteString, encodedURLString)
    }
    
    // MARK: - asData Tests
    
    func testAsData_WithBasicString_ShouldReturnExpectedData() {
        // Given a basic string
        let string = TestConstants.basicString
        let expectedData = string.data(using: .utf8)
        
        // When converting to Data
        let resultData = string.asData
        
        // Then should match expected data
        XCTAssertEqual(resultData, expectedData)
    }
    
    func testAsData_WithUnicodeString_ShouldReturnExpectedData() {
        // Given a string with Unicode characters
        let unicodeString = TestConstants.unicodeString
        let expectedData = unicodeString.data(using: .utf8)
        
        // When converting to Data
        let resultData = unicodeString.asData
        
        // Then should match expected data
        XCTAssertEqual(resultData, expectedData)
    }
    
    func testAsData_WithSpecialCharacters_ShouldReturnExpectedData() {
        // Given a string with special characters
        let specialString = TestConstants.specialCharacters
        let expectedData = specialString.data(using: .utf8)
        
        // When converting to Data
        let resultData = specialString.asData
        
        // Then should match expected data
        XCTAssertEqual(resultData, expectedData)
    }
    
    func testAsData_WithEmptyString_ShouldReturnEmptyData() {
        // Given an empty string
        let emptyString = ""
        
        // When converting to Data
        let resultData = emptyString.asData
        
        // Then should return empty Data
        XCTAssertEqual(resultData, Data())
        XCTAssertEqual(resultData?.count, 0)
    }
    
    func testAsData_WithMultilineString_ShouldReturnExpectedData() {
        // Given a multiline string
        let multilineString = TestConstants.multilineString
        let expectedData = multilineString.data(using: .utf8)
        
        // When converting to Data
        let resultData = multilineString.asData
        
        // Then should match expected data
        XCTAssertEqual(resultData, expectedData)
    }
    
    func testAsData_WithOptionalString_ShouldHandleNilCase() {
        // Given an optional string that's nil
        let nilString: String? = nil
        
        // When converting to Data
        let resultData = nilString?.asData
        
        // Then should return nil
        XCTAssertNil(resultData)
    }
}
