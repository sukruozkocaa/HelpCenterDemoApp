//
//  IconAndTitleView.swift
//  HelpCenterDemoApp
//
//  Created by Şükrü on 12.10.2024.
//

import UIKit

// MARK: - IconAndTitleView
final class IconAndTitleView: UIView {
    
    // MARK: - Views
    private lazy var contentHStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading
        let itemSpacing = IconAndTitleView.contentHStackViewItemSpacing
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
        label.font = IconAndTitleView.labelFont
        label.textAlignment = .left
        label.numberOfLines = .zero
        label.labelTextColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
            
    // MARK: - Static Constants
    static let iconImageViewFrame: CGFloat = 24.0
    static let contentHStackViewXMargin: CGFloat = 10.0
    static let contentHStackViewTopMargin: CGFloat = 10.0
    static let contentHStackViewItemSpacing: CGFloat = 9.0
    static let labelFont: UIFont = .systemFont(ofSize: 13.0, weight: .semibold)
    
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
private extension IconAndTitleView {
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
                constant: IconAndTitleView.contentHStackViewTopMargin
            ),
            contentHStackView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: IconAndTitleView.contentHStackViewXMargin
            ),
            contentHStackView.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -(IconAndTitleView.contentHStackViewXMargin)
            ),
            contentHStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    final func setupIconImageView() {
        contentHStackView.addArrangedSubview(iconImageView)
        
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(
                equalToConstant: IconAndTitleView.iconImageViewFrame
            ),
            iconImageView.heightAnchor.constraint(
                equalToConstant: IconAndTitleView.iconImageViewFrame
            )
        ])
    }
    
    final func setupTitleLabel() {
        contentHStackView.addArrangedSubview(titleLabel)
    }
}

// MARK: - Configure
extension IconAndTitleView {
    final func configure(infoText: String) {
        titleLabel.text = infoText
    }
}
