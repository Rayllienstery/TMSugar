//
//  Data.swift
//  TMSugar
//
//  Created by Kostiantyn Kolosov on 23.03.2025.
//

import SwiftUI

public extension Data {
    /// Converts Data to UIKit UIImage
    /// - Returns: UIKit.UIImage if data is valid UIImage, nil otherwise
    var asUIImage: UIImage? {
        UIImage(data: self)
    }

    /// Converts Data to SwiftUI Image
    /// - Returns: SwiftUI.Image object if data is valid, nil otherwise
    var asImage: Image? {
        guard let image = asUIImage else { return nil }
        return Image(uiImage: image)
    }

    /// Converts Data to  String
    /// - Returns: String if data is valid String, nil otherwise
    var asString: String? {
        String(data: self, encoding: .utf8)
    }

    /// Converts Data to JSON string
    /// - Returns: JSON string if data is valid JSON, nil otherwise
    var asJSONString: String? {
        guard let jsonObject = try? JSONSerialization.jsonObject(with: self),
              let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
              let jsonString = jsonData.asString else {
            return nil
        }
        return jsonString
    }
}
