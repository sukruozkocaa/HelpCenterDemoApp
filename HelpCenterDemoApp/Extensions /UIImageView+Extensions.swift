//
//  UIImageView+Extensions.swift
//  HelpCenterDemoApp
//
//  Created by Şükrü on 12.10.2024.
//

import UIKit
import Kingfisher

// MARK: - UIImageView Extensions 
extension UIImageView {
    
    // MARK: - Image Loading from URL
    // This method sets the image of the UIImageView by loading it from a given URL string.
    func setImageURL(url: String?) {
        guard let imageURLString = url, let imageURL = URL(string: imageURLString) else { return }        
        kf.setImage(with: imageURL)
    }
}
