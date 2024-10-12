//
//  HelpCenterInfoCell.swift
//  HelpCenterDemoApp
//
//  Created by Şükrü on 12.10.2024.
//

import UIKit

// MARK: - HelpCenterInfoCell
final class HelpCenterInfoCell: UITableViewCell {
    
    // MARK: - Views
    private lazy var contentVStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.setBorder(
            borderWidth: contentVStackViewBorderWidth,
            borderColor: .init(hexString: "#d1d1d1")
        )
        stackView.cornerRadius = contentVStackViewCornerRadius
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var iconAndTitleView: HelpCenterInfoIconAndTitleView = {
        let helpCenterInfoIconAndTitleView = HelpCenterInfoIconAndTitleView()
        return helpCenterInfoIconAndTitleView
    }()
    
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Konuşmayı bitir", for: .normal)
        button.backgroundColor = .init(hexString: "5D3DBC")
        button.setBorder(
            borderWidth: actionButtonBorderWidth,
            borderColor: .init(hexString: "d1d1d1")
        )
        button.titleLabel?.setFont(size: 13.0, weight: .semibold)
        button.cornerRadius = actionButtonCornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Variables
    
    // MARK: - Constants
    private let actionButtonCornerRadius: CGFloat = 10.0
    private let actionButtonBorderWidth: CGFloat = 0.5
    private let contentVStackViewBorderWidth: CGFloat = 0.5
    private let contentVStackViewCornerRadius: CGFloat = 10.0

    // MARK: - Static Constants
    static let actionButtonHeight: CGFloat = 40.0
    static let contentVStackViewItemSpacing: CGFloat = 20.0
    static let contentVStackViewXMargin: CGFloat = 16.0
    
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
private extension HelpCenterInfoCell {
    final func setupUI() {
        setupViewUI()
        setupContentVStackView()
        setupIconAndTitleView()
        setupActionButton()
    }
    
    final func setupViewUI() {
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    final func setupContentVStackView() {
        contentView.addSubview(contentVStackView)
        
        NSLayoutConstraint.activate([
            contentVStackView.topAnchor.constraint(equalTo: topAnchor),
            contentVStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentVStackView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: HelpCenterInfoCell.contentVStackViewXMargin
            ),
            contentVStackView.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -(HelpCenterInfoCell.contentVStackViewXMargin)
            )
        ])
    }
    
    final func setupIconAndTitleView() {
        contentVStackView.addArrangedSubview(iconAndTitleView)
    }
    
    final func setupActionButton() {
        contentVStackView.addArrangedSubview(actionButton)
        actionButton.heightAnchor.constraint(
            equalToConstant: HelpCenterInfoCell.actionButtonHeight
        ).isActive = true
    }
}

// MARK: - Configure
extension HelpCenterInfoCell {
    final func configure(item: HelpCenterResponseModel) {
        switch item.content {
        case .text(let text):
            iconAndTitleView.configure(infoText: text)
        case .buttons(_):
            break
        case .none:
            break
        }
    }
}
