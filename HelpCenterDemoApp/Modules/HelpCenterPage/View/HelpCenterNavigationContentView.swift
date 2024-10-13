//
//  HelpCenterNavigationContentView.swift
//  HelpCenterDemoApp
//
//  Created by Şükrü on 13.10.2024.
//

import Foundation
import UIKit

// MARK: - HelpCenterNavigationContentView
final class HelpCenterNavigationContentView: UIView {
    
    // MARK: - Views
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "ic-n11-badge")
        imageView.setBorder(
            borderWidth: iconImageViewBorderWidth,
            borderColor: .init(hexString: "24FF00")
        )
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Destek Merkezi"
        label.numberOfLines = 1
        label.textAlignment = .left
        label.setFont(
            size: titleLabelFontSize,
            weight: .medium
        )
        label.labelTextColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var contentHStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = contentHStackViewItemSpacing
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Constants
    private let contentHStackViewItemSpacing: CGFloat = 8.0
    private let titleLabelFontSize: CGFloat = 16.0
    private let iconImageViewBorderWidth: CGFloat = 1.5
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        iconImageView.cornerRadius = frame.height/2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup UI
private extension HelpCenterNavigationContentView {
    final func setupUI() {
        setupViewUI()
        setupContentHStackView()
        setupIconImageView()
        setupTitleLabel()
    }
    
    final func setupViewUI() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    final func setupContentHStackView() {
        addSubview(contentHStackView)
        
        NSLayoutConstraint.activate([
            contentHStackView.topAnchor.constraint(equalTo: topAnchor),
            contentHStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentHStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
        ])
    }
    
    final func setupIconImageView() {
        contentHStackView.addArrangedSubview(iconImageView)
        iconImageView.widthAnchor.constraint(equalTo: heightAnchor).isActive = true
        iconImageView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
    
    final func setupTitleLabel() {
        contentHStackView.addArrangedSubview(titleLabel)
    }
}

// MARK: - Configure
extension HelpCenterNavigationContentView {
    final func configure(isConnectWebSocket: Bool) {
        let borderColor: UIColor = isConnectWebSocket ? .init(hexString: "24FF00"): .init(hexString: "#BFBFBF")
        iconImageView.setBorder(borderColor: borderColor)
    }
}
