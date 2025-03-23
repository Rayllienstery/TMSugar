//
//  File.swift
//  MyLibrary
//
//  Created by Kostiantyn Kolosov on 23.03.2025.
//

import Foundation

public extension String {
    var asURL: URL? {
        guard self.contains(" ") == false else { return nil }
        guard let url = URL(string: self) else { return nil }
        guard url.host != nil else { return nil }

        return url
    }

    var asData: Data? { data(using: .utf8) }
}
