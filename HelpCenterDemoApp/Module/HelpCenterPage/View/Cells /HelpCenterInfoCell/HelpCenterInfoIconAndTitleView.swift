//
//  HelpCenterInfoIconAndTitleView.swift
//  HelpCenterDemoApp
//
//  Created by Şükrü on 12.10.2024.
//

import UIKit

// MARK: - HelpCenterInfoIconAndTitleView
final class HelpCenterInfoIconAndTitleView: UIView {
    
    // MARK: - Views
    private lazy var contentHStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading
        let itemSpacing = HelpCenterInfoIconAndTitleView.contentHStackViewItemSpacing
        stackView.spacing = itemSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic-n11-badge")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.setFont(size: 13.0, weight: .semibold)
        label.textAlignment = .left
        label.numberOfLines = .zero
        label.labelTextColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
            
    // MARK: - Static Constants
    static let contentHStackViewItemSpacing: CGFloat = 9.0
    static let iconImageViewFrame: CGFloat = 24.0
    static let contentHStackViewTopMargin: CGFloat = 10.0
    static let contentHStackViewXMargin: CGFloat = 10.0
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup UI
private extension HelpCenterInfoIconAndTitleView {
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
            contentHStackView.topAnchor.constraint(
                equalTo: topAnchor,
                constant: HelpCenterInfoIconAndTitleView.contentHStackViewTopMargin
            ),
            contentHStackView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: HelpCenterInfoIconAndTitleView.contentHStackViewXMargin
            ),
            contentHStackView.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -(HelpCenterInfoIconAndTitleView.contentHStackViewXMargin)
            ),
            contentHStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    final func setupIconImageView() {
        contentHStackView.addArrangedSubview(iconImageView)
        
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(
                equalToConstant: HelpCenterInfoIconAndTitleView.iconImageViewFrame
            ),
            iconImageView.heightAnchor.constraint(
                equalToConstant: HelpCenterInfoIconAndTitleView.iconImageViewFrame
            )
        ])
    }
    
    final func setupTitleLabel() {
        contentHStackView.addArrangedSubview(titleLabel)
    }
}

// MARK: - Configure
extension HelpCenterInfoIconAndTitleView {
    final func configure(infoText: String) {
        titleLabel.text = infoText
    }
}
