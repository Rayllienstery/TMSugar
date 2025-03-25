//
//  File.swift
//  MyLibrary
//
//  Created by Kostiantyn Kolosov on 23.03.2025.
//

import Foundation

public extension String {
    // MARK: - URL
    /// Converts String to URL
    /// - Returns: URL if data is valid URL, nil otherwise
    var asURL: URL? {
        guard self.contains(" ") == false else { return nil }
        guard let url = URL(string: self) else { return nil }
        guard url.host != nil else { return nil }

        return url
    }

    /**
     Extracts URLs from a string.
     
     - Returns: Array of URLs found in the string
     - Throws: NSDataDetector initialization error
     */
    func extractURLs() throws -> [URL] {
        let types: NSTextCheckingResult.CheckingType = .link
        
        let detector = try NSDataDetector(types: types.rawValue)
        let matches = detector.matches(
            in: self,
            options: .reportCompletion,
            range: NSRange(location: 0, length: self.count)
        )
        
        return matches.compactMap { $0.url }
    }

    /// Converts String to File URL
    /// - Returns: URL if String is valid URL, nil otherwise
    func convertToFileURL() -> URL? {
        let fileURL = URL(fileURLWithPath: self)
        return fileURL
    }

    // MARK: - Data
    /// Converts String to Data
    /// - Returns: Data if data is valid Data, nil otherwise
    var asData: Data? { data(using: .utf8) }
}
