//
//  StringURLExtensionTests.swift
//  TMSugar
//
//  Created by Kostiantyn Kolosov on 24.03.2025.
//

import XCTest

class StringURLExtensionTests: XCTestCase {
    
    // MARK: - Test Data
    
    private let validURLString = "Check out https://www.example.com and http://test.com"
    private let invalidURLString = "No URLs here"
    private let multipleURLString = "First https://first.com second http://second.com"
    
    // MARK: - Tests
    
    func testExtractURLs_WithValidURL() throws {
        let urls = try validURLString.extractURLs()
        
        XCTAssertEqual(urls.count, 2)
        XCTAssertEqual(urls[0].absoluteString, "https://www.example.com")
        XCTAssertEqual(urls[1].absoluteString, "http://test.com")
    }
    
    func testExtractURLs_WithInvalidURL() throws {
        let urls = try invalidURLString.extractURLs()
        
        XCTAssertTrue(urls.isEmpty)
    }
    
    func testExtractURLs_WithMultipleURLs() throws {
        let urls = try multipleURLString.extractURLs()
        
        XCTAssertEqual(urls.count, 2)
        XCTAssertEqual(urls[0].absoluteString, "https://first.com")
        XCTAssertEqual(urls[1].absoluteString, "http://second.com")
    }
    
    func testExtractURLs_WithEmptyString() throws {
        let urls = try "".extractURLs()
        
        XCTAssertTrue(urls.isEmpty)
    }
}
