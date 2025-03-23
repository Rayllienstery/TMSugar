//
//  Data.swift
//  TMSugar
//
//  Created by Kostiantyn Kolosov on 23.03.2025.
//

import SwiftUI

public extension Data {
    var asUIImage: UIImage? {
        UIImage(data: self)
    }

    var asImage: Image? {
        guard let image = asUIImage else { return nil }
        return Image(uiImage: image)
    }

    var asString: String? {
        String(data: self, encoding: .utf8)
    }
}
