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
    // 'url': An optional string that represents the image URL.
    // The method safely unwraps the URL string and converts it to a URL object.
    // If the URL is valid, it uses Kingfisher's 'kf.setImage' method to load and set the image.
    // If the URL string is invalid or nil, the function simply returns without doing anything.
    func setImageURL(url: String?) {
        guard let imageURLString = url, let imageURL = URL(string: imageURLString) else { return }
        
        // Uses Kingfisher library to asynchronously load and set the image.
        kf.setImage(with: imageURL)
    }
}
