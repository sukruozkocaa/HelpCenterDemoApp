//
//  UIImageView+Extensions.swift
//  HelpCenterDemoApp
//
//  Created by Şükrü on 12.10.2024.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setImageURL(url: String?) {
        guard let imageURLString = url, let imageURL = URL(string: imageURLString) else { return }
        kf.setImage(with: imageURL)
    }
}
