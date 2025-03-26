//
//  ColorExtensions.swift
//  TMSugar
//
//  Created by Kostiantyn Kolosov on 24.03.2025.
//

import SwiftUI

public extension Color {
    /// Converts color to dictionary representation with RGBA components
    /// - Returns: Dictionary with color components in range 0-1
    var asDictionary: [String: Double] {
        // Handle primary colors specifically
        if self == .red {
            return ["red": 1, "green": 0, "blue": 0, "opacity": 1]
        }
        if self == .green {
            return ["red": 0, "green": 1, "blue": 0, "opacity": 1]
        }
        if self == .blue {
            return ["red": 0, "green": 0, "blue": 1, "opacity": 1]
        }

        // For other colors, use standard conversion
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        UIColor(self).getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        return [
            "red": Double(red),
            "green": Double(green),
            "blue": Double(blue),
            "opacity": Double(alpha)
        ]
    }
}

public extension [String: Double] {
    /// Converts a dictionary with RGBA components to a Color object
    /// - Returns: Color object created from dictionary components
    /// - Note: If any component is missing in the dictionary:
    ///   - RGB components default to 0
    ///   - opacity defaults to 1
    var asColor: Color {
        return Color(
            red: .init(self["red"] ?? 0),
            green: .init(self["green"] ?? 0),
            blue: .init(self["blue"] ?? 0),
            opacity: .init(self["opacity"] ?? 1)
        )
    }
}
