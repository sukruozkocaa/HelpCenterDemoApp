//
//  HelpCenterChatClientBubbleView.swift
//  HelpCenterDemoApp
//
//  Created by Şükrü on 12.10.2024.
//

import UIKit

// MARK: - HelpCenterChatClientBubbleView
final class HelpCenterChatClientBubbleView: UIView {
    
    // MARK: - Views
    private lazy var contentVStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.cornerRadius = stackViewCornerRadius
        stackView.setBorder(
            borderWidth: stackViewBorderWidth,
            borderColor: .init(hexString: "d1d1d1")
        )
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var leftSpacerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var rightSpacerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = .zero
        label.setFont(size: 14.0, weight: .regular)
        label.labelTextColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Constants
    private let spacerViewWidth: CGFloat = 15.0
    private let stackViewBorderWidth: CGFloat = 0.5
    private let stackViewCornerRadius: CGFloat = 20.0
    private let stackViewLeadingMargin: CGFloat = 16.0
    private let stackViewTrailingMargin: CGFloat = 32.0
    
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
private extension HelpCenterChatClientBubbleView {
    final func setupUI() {
        setupViewUI()
        setupContentVStackView()
        setupLeftSpacerView()
        setupTextLabel()
        setupRightSpacerView()
    }
    
    final func setupViewUI() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    final func setupContentVStackView() {
        addSubview(contentVStackView)
        
        NSLayoutConstraint.activate([
            contentVStackView.topAnchor.constraint(equalTo: topAnchor),
            contentVStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentVStackView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: stackViewLeadingMargin
            ),
            contentVStackView.trailingAnchor.constraint(
                lessThanOrEqualTo: trailingAnchor,
                constant: -(stackViewTrailingMargin)
            )
        ])
    }
    
    final func setupLeftSpacerView() {
        contentVStackView.addArrangedSubview(leftSpacerView)
        leftSpacerView.widthAnchor.constraint(equalToConstant: spacerViewWidth).isActive = true
    }
    
    final func setupTextLabel() {
        contentVStackView.addArrangedSubview(textLabel)
    }
    
    final func setupRightSpacerView() {
        contentVStackView.addArrangedSubview(rightSpacerView)
        rightSpacerView.widthAnchor.constraint(equalToConstant: spacerViewWidth).isActive = true
    }
}

// MARK: - Configure
extension HelpCenterChatClientBubbleView {
    final func configure(bubbleMessage: String) {
        textLabel.text = bubbleMessage
    }
}
