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
    func setFont(size: CGFloat, weight: UIFont.Weight) {
        font = .systemFont(ofSize: size, weight: weight)
        sizeToFit()
    }
    
    var labelTextColor: UIColor {
        get {
            return self.textColor
        }
        
        set {
            self.textColor = newValue
        }
    }
}
