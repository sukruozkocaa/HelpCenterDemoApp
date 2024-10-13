//
//  UIView+Extensions .swift
//  HelpCenterDemoApp
//
//  Created by Şükrü on 12.10.2024.
//

import Foundation
import UIKit

// MARK: - UIView Extensions 
extension UIView {

    // MARK: - Corner Radius Extension
    // 'cornerRadius' property: Used to set or get the corner radius of the UIView.
    // Getter: Returns the current corner radius of the UIView.
    // Setter: Updates the corner radius of the UIView.
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        
        set {
            layer.cornerRadius = newValue
        }
    }
    
    // 'setBorder' function: Used to set the border width and color of the UIView.
    // 'borderWidth': Specifies the width of the border (optional).
    // 'borderColor': Specifies the color of the border (optional).
    func setBorder(borderWidth: CGFloat? = nil, borderColor: UIColor? = nil) {
        if let layerBorderWidth = borderWidth {
            // If 'borderWidth' is provided, apply it as the border width.
            layer.borderWidth = layerBorderWidth
        }
        
        if let layerBorderColor = borderColor {
            // If 'borderColor' is provided, apply it as the border color.
            layer.borderColor = layerBorderColor.cgColor
        }
    }
}
