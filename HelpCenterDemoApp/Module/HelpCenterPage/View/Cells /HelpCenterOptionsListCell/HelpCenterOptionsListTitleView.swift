//
//  HelpCenterOptionsListTitleView.swift
//  HelpCenterDemoApp
//
//  Created by Şükrü on 12.10.2024.
//

import Foundation
import UIKit

// MARK: - HelpCenterOptionsListTitleView
final class HelpCenterOptionsListTitleView: UIView {
    
    // MARK: - Views
    private lazy var titleContainerView: UIView = {
        let view = UIView()
        view.cornerRadius = containerViewCornerRadius
        view.setBorder(
            borderWidth: containerViewBorderWidth,
            borderColor: .init(hexString: "D1D1D1")
        )
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.setFont(size: titleLabelFontSize, weight: .regular)
        label.labelTextColor = .init(hexString: "000000")
        label.textAlignment = .left
        label.numberOfLines = .zero
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Variables
    
    // MARK: - Constants
    private let containerViewCornerRadius: CGFloat = 8.0
    private let containerViewBorderWidth: CGFloat = 1.0
    private let titleLabelXMargin: CGFloat = 13.0
    private let titleLabelFontSize: CGFloat = 14.0
    
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
private extension HelpCenterOptionsListTitleView {
    final func setupUI() {
        setupViewUI()
        setupTitleContainerView()
        setupTitleLabel()
    }
    
    final func setupViewUI() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    final func setupTitleContainerView() {
        addSubview(titleContainerView)
        
        NSLayoutConstraint.activate([
            titleContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleContainerView.topAnchor.constraint(equalTo: topAnchor),
            titleContainerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    final func setupTitleLabel() {
        titleContainerView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: titleContainerView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(
                equalTo: titleContainerView.leadingAnchor,
                constant: titleLabelXMargin
            ),
            titleLabel.trailingAnchor.constraint(
                equalTo: titleContainerView.trailingAnchor,
                constant: -(titleLabelXMargin)
            )
        ])
    }
}

// MARK: - Configure
extension HelpCenterOptionsListTitleView {
    final func configure(title: String) {
        titleLabel.text = title
    }
}
