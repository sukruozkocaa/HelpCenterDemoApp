//
//  UIColor+Extensions .swift
//  HelpCenterDemoApp
//
//  Created by Şükrü on 12.10.2024.
//

import Foundation
import UIKit

// MARK: - UIColor Extensions 
extension UIColor {
    
    // Convenience initializer for UIColor using a hexadecimal integer and optional alpha.
    // 'hex': Hexadecimal color value (e.g., 0xFF5733 for a specific color).
    // 'alpha': Optional alpha value (opacity), default is 1.0 (fully opaque).
    convenience init(_ hex: Int, alpha: Double = 1.0) {
        self.init(
            red: CGFloat((hex >> 16) & 0xFF) / 255.0,
            green: CGFloat((hex >> 8) & 0xFF) / 255.0,
            blue: CGFloat((hex) & 0xFF) / 255.0,
            alpha: CGFloat(255 * alpha) / 255
        )
    }

    // Convenience initializer for UIColor using a hex string and optional alpha.
    // 'hexString': Hexadecimal color value in string format (e.g., "#FF5733").
    // 'alpha': Optional alpha value, default is 1.0.
    convenience init(hexString: String, alpha: Double = 1.0) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)

        let r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (r, g, b) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (1, 1, 0)
        }

        self.init(
            red: CGFloat(r) / 255,
            green: CGFloat(g) / 255,
            blue: CGFloat(b) / 255,
            alpha: CGFloat(255 * alpha) / 255
        )
    }
    
    // Convenience initializer for UIColor using RGB values and an optional alpha.
    // 'r': Red value (0-255).
    // 'g': Green value (0-255).
    // 'b': Blue value (0-255).
    // 'a': Alpha value (0-1), default is 1 (fully opaque).
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1) {
        self.init(
            red: (r / 255),
            green: (g / 255),
            blue: (b / 255),
            alpha: a
        )
    }
}
