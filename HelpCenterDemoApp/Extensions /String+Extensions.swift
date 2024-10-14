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
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        
        // Calculates the bounding box for the string using the constraint size and font, and the `.usesLineFragmentOrigin` option,
        // which ensures the text is laid out as it would be in a multi-line label or text view.
        let boundingBox = self.boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font: font],
            context: nil
        )
        
        return boundingBox.height
    }
    
    // MARK: - Calculate Width with Constrained Height
    // This method calculates the width required to display the string within a specified height and font.
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        
        // Calculates the bounding box for the string using the constraint size and font, and the `.usesLineFragmentOrigin` option,
        // which ensures the text is laid out as it would be in a multi-line label or text view.
        let boundingBox = self.boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font: font],
            context: nil
        )

        return ceil(boundingBox.width)
    }
}
