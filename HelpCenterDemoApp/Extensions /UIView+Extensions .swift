//
//  UIView+Extensions .swift
//  HelpCenterDemoApp
//
//  Created by Şükrü on 12.10.2024.
//

import Foundation
import UIKit

extension UIView {

    // MARK: - Corner Radius Extension
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        
        set {
            layer.cornerRadius = newValue
        }
    }
    
    func setBorder(borderWidth: CGFloat? = nil, borderColor: UIColor? = nil) {
        if let layerBorderWidth = borderWidth {
            layer.borderWidth = layerBorderWidth
        }
        
        if let layerBorderColor = borderColor {
            layer.borderColor = layerBorderColor.cgColor
        }
    }
}
