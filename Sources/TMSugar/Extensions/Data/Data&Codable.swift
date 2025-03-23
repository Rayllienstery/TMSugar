//
//  Data&Codable.swift
//  TMSugar
//
//  Created by Kostiantyn Kolosov on 23.03.2025.
//

import Foundation

// MARK: - Data Extension
extension Data {
    /// Converts Data to a specified Decodable object type
    /// - Parameters:
    ///   - type: The type to decode the data into
    ///   - decoder: JSONDecoder instance with default configuration
    ///   - keyDecodingStrategy: Optional key decoding strategy
    ///   - dateDecodingStrategy: Optional date decoding strategy
    /// - Returns: Decoded object of specified type
    /// - Throws: DataConversionError
    func asObject<T: Decodable>(
        of type: T.Type,
        using decoder: JSONDecoder = JSONDecoder(),
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy? = nil,
        dateDecodingStrategy: JSONDecoder.DateDecodingStrategy? = nil
    ) throws -> T {
        if let keyStrategy = keyDecodingStrategy {
            decoder.keyDecodingStrategy = keyStrategy
        }
        
        if let dateStrategy = dateDecodingStrategy {
            decoder.dateDecodingStrategy = dateStrategy
        }
        
        do {
            return try decoder.decode(type, from: self)
        } catch {
            throw DataConversionError.decodingFailed(error)
        }
    }
    
    /// Async version of asObject
    /// - Parameters:
    ///   - type: The type to decode the data into
    ///   - decoder: JSONDecoder instance
    /// - Returns: Decoded object of specified type
    /// - Throws: DataConversionError
    func asObject<T: Decodable>(
        of type: T.Type,
        using decoder: JSONDecoder = JSONDecoder()
    ) async throws -> T {
        try await withCheckedThrowingContinuation { continuation in
            do {
                let result = try decoder.decode(type, from: self)
                continuation.resume(returning: result)
            } catch {
                continuation.resume(throwing: DataConversionError.decodingFailed(error))
            }
        }
    }
}

// MARK: - Encodable Extension
extension Encodable {
    /// Converts the Encodable object to Data
    /// - Parameters:
    ///   - encoder: JSONEncoder instance
    ///   - keyEncodingStrategy: Optional key encoding strategy
    ///   - dateEncodingStrategy: Optional date encoding strategy
    /// - Returns: Encoded data
    /// - Throws: DataConversionError
    func toData(
        using encoder: JSONEncoder = JSONEncoder(),
        keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy? = nil,
        dateEncodingStrategy: JSONEncoder.DateEncodingStrategy? = nil
    ) throws -> Data {
        if let keyStrategy = keyEncodingStrategy {
            encoder.keyEncodingStrategy = keyStrategy
        }
        
        if let dateStrategy = dateEncodingStrategy {
            encoder.dateEncodingStrategy = dateStrategy
        }
        
        do {
            return try encoder.encode(self)
        } catch {
            throw DataConversionError.encodingFailed(error)
        }
    }
    
    /// Async version of toData
    /// - Parameter encoder: JSONEncoder instance
    /// - Returns: Encoded data
    /// - Throws: DataConversionError
    func toData(
        using encoder: JSONEncoder = JSONEncoder()
    ) async throws -> Data {
        try await withCheckedThrowingContinuation { continuation in
            do {
                let result = try encoder.encode(self)
                continuation.resume(returning: result)
            } catch {
                continuation.resume(throwing: DataConversionError.encodingFailed(error))
            }
        }
    }
}
