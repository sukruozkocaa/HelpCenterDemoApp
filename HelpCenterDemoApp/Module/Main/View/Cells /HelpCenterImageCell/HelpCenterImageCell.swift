//
//  HelpCenterImageCell.swift
//  HelpCenterDemoApp
//
//  Created by Şükrü on 12.10.2024.
//

import UIKit

// MARK: - HelpCenterImageCellDelegate
protocol HelpCenterImageCellDelegate: AnyObject {
    func helpCenterImageCell(didTapImage image: UIImage)
}

// MARK: - HelpCenterImageCell
final class HelpCenterImageCell: UITableViewCell {

    // MARK: - Views
    private lazy var infoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.setBorder(
            borderWidth: infoImageViewBorderWidth,
            borderColor: .init(hexString: "d1d1d1")
        )
        
        imageView.cornerRadius = infoImageViewCornerRadius
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapToImageView))
        imageView.addGestureRecognizer(gesture)
        return imageView
    }()
    
    // MARK: - Constants
    private let infoImageViewCornerRadius: CGFloat = 10.0
    private let infoImageViewXMargin: CGFloat = 16.0
    private let infoImageViewBorderWidth: CGFloat = 0.5
    
    // MARK: - Delegates
    weak var delegate: HelpCenterImageCellDelegate?
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Setup UI
private extension HelpCenterImageCell {
    final func setupUI() {
        setupViewUI()
        setupInfoImageView()
    }
    
    final func setupViewUI() {
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    final func setupInfoImageView() {
        contentView.addSubview(infoImageView)
        
        NSLayoutConstraint.activate([
            infoImageView.topAnchor.constraint(equalTo: topAnchor),
            infoImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            infoImageView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: infoImageViewXMargin
            ),
            infoImageView.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -(infoImageViewXMargin)
            )
        ])
    }
}

// MARK: - Configure
extension HelpCenterImageCell {
    final func configure(imageURLString: String?) {
        // TODO: Implements new URL
        let imageURL: String = "https://media.licdn.com/dms/image/v2/D4D22AQE091hLQw1pUQ/feedshare-shrink_1280/feedshare-shrink_1280/0/1703068677936?e=1731542400&v=beta&t=gRS0cWOIPOPakhFI1u7hqSpZLAPG57kXZRMu5yrK5Og"
        
        infoImageView.setImageURL(url: imageURL)
    }
}

// MARK: - Tap To Handlers
@objc
private extension HelpCenterImageCell {
    final func tapToImageView() {
        guard let image = infoImageView.image else { return }
        delegate?.helpCenterImageCell(didTapImage: image)
    }
}
