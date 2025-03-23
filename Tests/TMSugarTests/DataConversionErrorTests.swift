//
//  DataConversionErrorTests.swift
//  TMSugar
//
//  Created by Kostiantyn Kolosov on 23.03.2025.
//

import XCTest
@testable import TMSugar

extension DataConversionError: Equatable {
    public static func == (lhs: DataConversionError, rhs: DataConversionError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidData, .invalidData):
            return true
        case let (.decodingFailed(lhsError), .decodingFailed(rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        case let (.encodingFailed(lhsError), .encodingFailed(rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}

class DataConversionErrorTests: XCTestCase {
    
    // MARK: - Test Cases
    
    func testInvalidDataError() {
        // Given
        let error = DataConversionError.invalidData
        
        // When
        let errorDescription = error.errorDescription
        
        // Then
        XCTAssertEqual(errorDescription, "The provided data is invalid")
    }
    
    func testDecodingFailedError() {
        // Given
        let mockError = NSError(domain: "TestDomain", code: 1, userInfo: [
            NSLocalizedDescriptionKey: "Mock decoding error"
        ])
        let error = DataConversionError.decodingFailed(mockError)
        
        // When
        let errorDescription = error.errorDescription
        
        // Then
        XCTAssertEqual(errorDescription, "Failed to decode data: Mock decoding error")
    }
    
    func testEncodingFailedError() {
        // Given
        let mockError = NSError(domain: "TestDomain", code: 1, userInfo: [
            NSLocalizedDescriptionKey: "Mock encoding error"
        ])
        let error = DataConversionError.encodingFailed(mockError)
        
        // When
        let errorDescription = error.errorDescription
        
        // Then
        XCTAssertEqual(errorDescription, "Failed to encode object: Mock encoding error")
    }
    
    func testEquatability() {
        // Given
        let error1 = DataConversionError.invalidData
        let error2 = DataConversionError.invalidData
        let mockError = NSError(domain: "TestDomain", code: 1)
        let error3 = DataConversionError.decodingFailed(mockError)
        
        // Then
        XCTAssertEqual(error1, error2)
        XCTAssertNotEqual(error1, error3)
    }
    
    func testAssociatedValuesPreservation() {
        // Given
        let originalError = NSError(domain: "TestDomain", code: 1, userInfo: [
            NSLocalizedDescriptionKey: "Original error"
        ])
        let error = DataConversionError.decodingFailed(originalError)
        
        // When
        if case .decodingFailed(let extractedError) = error {
            // Then
            XCTAssertEqual(extractedError.localizedDescription, originalError.localizedDescription)
        } else {
            XCTFail("Failed to extract associated value")
        }
    }
}
