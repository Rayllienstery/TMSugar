//
//  DataConversionError.swift
//  TMSugar
//
//  Created by Kostiantyn Kolosov on 23.03.2025.
//

import Foundation

public enum DataConversionError: LocalizedError {
    case invalidData
    case decodingFailed(Error)
    case encodingFailed(Error)

    // Adding localized error description for better error handling
    public var errorDescription: String? {
        switch self {
        case .invalidData:
            return "The provided data is invalid"
        case .decodingFailed(let error):
            return "Failed to decode data: \(error.localizedDescription)"
        case .encodingFailed(let error):
            return "Failed to encode object: \(error.localizedDescription)"
        }
    }
}
