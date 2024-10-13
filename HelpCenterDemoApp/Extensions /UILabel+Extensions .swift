//
//  UILabel+Extensions .swift
//  HelpCenterDemoApp
//
//  Created by Şükrü on 12.10.2024.
//

import Foundation
import UIKit

// MARK: - UILabel Extensions 
extension UILabel {
    
    // Sets the font of the UILabel using the system font with a specified size and weight.
    // 'size': The size of the font to apply.
    // 'weight': The weight (boldness) of the font, using UIFont.Weight.
    func setFont(size: CGFloat, weight: UIFont.Weight) {
        // Applies the system font with the given size and weight.
        font = .systemFont(ofSize: size, weight: weight)
        
        // Resizes the label to fit the text after changing the font.
        sizeToFit()
    }
    
    // Computed property to get and set the text color of the UILabel.
    var labelTextColor: UIColor {
        get {
            // Retrieves the current text color of the label.
            return self.textColor
        }
        
        set {
            // Sets the new text color of the label.
            self.textColor = newValue
        }
    }
}
