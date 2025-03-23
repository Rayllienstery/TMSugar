//
//  Encodable.swift
//  TMSugar
//
//  Created by Kostiantyn Kolosov on 23.03.2025.
//

import Foundation

extension Encodable {
    func asJSONString() throws -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        do {
            let jsonData = try encoder.encode(self)
            guard let jsonString = String(data: jsonData, encoding: .utf8) else {
                throw DataConversionError.invalidData
            }
            return jsonString
        } catch {
            throw DataConversionError.encodingFailed(error)
        }
    }
}
