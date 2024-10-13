//
//  String+Extensions.swift
//  HelpCenterDemoApp
//
//  Created by Şükrü on 12.10.2024.
//

import Foundation
import UIKit

// MARK: - String Extensions
extension String {

    // MARK: - Calculate Height with Constrained Width
    // This method calculates the height required to display the string within a specified width and font.
    // 'width': The maximum width for the text.
    // 'font': The font used to display the text.
    // The method calculates the bounding box of the text (its height and width) and returns the required height to fit the text in the given width.
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        
        // Creates a constraint size with the specified width and an extremely large height to ensure the text height can grow freely.
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        
        // Calculates the bounding box for the string using the constraint size and font, and the `.usesLineFragmentOrigin` option,
        // which ensures the text is laid out as it would be in a multi-line label or text view.
        let boundingBox = self.boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font: font],
            context: nil
        )
        
        // Returns the calculated height of the bounding box.
        return boundingBox.height
        
    }
    
    // MARK: - Calculate Width with Constrained Height
    // This method calculates the width required to display the string within a specified height and font.
    // 'height': The maximum height for the text.
    // 'font': The font used to display the text.
    // The method calculates the bounding box of the text (its height and width) and returns the required width to fit the text in the given height.
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        
        // Creates a constraint size with an extremely large width to ensure the text width can grow freely and the specified height.
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        
        // Calculates the bounding box for the string using the constraint size and font, and the `.usesLineFragmentOrigin` option,
        // which ensures the text is laid out as it would be in a multi-line label or text view.
        let boundingBox = self.boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font: font],
            context: nil
        )

        // Rounds up the calculated width value using `ceil()` to avoid fractional pixel values.
        return ceil(boundingBox.width)
    }
}
