//
//  HelpCenterChatButtonListContentItemCell.swift
//  HelpCenterDemoApp
//
//  Created by Şükrü on 12.10.2024.
//

import UIKit

// MARK: - HelpCenterChatButtonListContentItemCellDelegate
protocol HelpCenterChatButtonListContentItemCellDelegate: AnyObject {
    func helpCenterChatButtonListContentItemCell(didTapButton button: HelpCenterContentButtonModel)
}

// MARK: - HelpCenterChatButtonListContentItemCell
final class HelpCenterChatButtonListContentItemCell: UITableViewCell {

    // MARK: - Views
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.setTitleColor(.init(hexString: "1e1e1e"), for: .normal)
        button.contentEdgeInsets.left = 16.0
        button.titleLabel?.textAlignment = .left
        button.titleLabel?.setFont(size: 15.0, weight: .semibold)
        button.addTarget(self, action: #selector(tapToSelectItem), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Variables
    private var buttonDetail: HelpCenterContentButtonModel?
    
    // MARK: - Delegates
    weak var delegate: HelpCenterChatButtonListContentItemCellDelegate?
    
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
private extension HelpCenterChatButtonListContentItemCell {
    final func setupUI() {
        setupViewUI()
        setupActionButton()
    }
    
    final func setupViewUI() {
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    final func setupActionButton() {
        contentView.addSubview(actionButton)
        
        NSLayoutConstraint.activate([
            actionButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            actionButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            actionButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            actionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}

// MARK: - Configure
extension HelpCenterChatButtonListContentItemCell {
    final func configure(button: HelpCenterContentButtonModel) {
        self.buttonDetail = button
        actionButton.setTitle(button.label, for: .normal)
    }
}

// MARK: - Tap To Handlers
@objc
private extension HelpCenterChatButtonListContentItemCell {
    final func tapToSelectItem() {
        guard let buttonDetail = self.buttonDetail else { return }
        delegate?.helpCenterChatButtonListContentItemCell(didTapButton: buttonDetail)
    }
}
