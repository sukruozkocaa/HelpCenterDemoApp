//
//  HelpCenterChatButtonListCell.swift
//  HelpCenterDemoApp
//
//  Created by Şükrü on 12.10.2024.
//

import UIKit

// MARK: - HelpCenterChatButtonListCellDelegate
protocol HelpCenterChatButtonListCellDelegate: AnyObject {
    func helpCenterChatButtonListCell(didTapButton button: HelpCenterContentButtonModel)
}

// MARK: - HelpCenterChatButtonListCell
final class HelpCenterChatButtonListCell: UITableViewCell {

    // MARK: - Views
    private lazy var titleView: HelpCenterChatButtonListTitleView = {
        let helpCenterOptionsListTitleView = HelpCenterChatButtonListTitleView()
        return helpCenterOptionsListTitleView
    }()
    
    private lazy var buttonListView: HelpCenterChatButtonListContentView = {
        let helpOptionsButtonListView = HelpCenterChatButtonListContentView()
        helpOptionsButtonListView.delegate = self
        return helpOptionsButtonListView
    }()
    
    // MARK: - Variables
    
    // MARK: - Constants
    private let titleViewXMargin: CGFloat = 16.0
    private let buttonListViewXMargin: CGFloat = 16.0

    // MARK: - Static Constants
    static let titleViewHeight: CGFloat = 56.0
    static let buttonListViewTopMargin: CGFloat = 10.0

    // MARK: - Delegates
    weak var delegate: HelpCenterChatButtonListCellDelegate?
    
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
private extension HelpCenterChatButtonListCell {
    final func setupUI() {
        setupViewUI()
        setupTitleView()
        setupButtonListView()
    }
    
    final func setupViewUI() {
        selectionStyle = .none
        backgroundColor = .clear
    }
    
    final func setupTitleView() {
        contentView.addSubview(titleView)
        
        // TODO: - Calculate to titleView height in label text height
        // TODO: - Constraint fill superview extension apply
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleView.heightAnchor.constraint(equalToConstant: HelpCenterChatButtonListCell.titleViewHeight),
            titleView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: titleViewXMargin
            ),
            titleView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -(titleViewXMargin)
            )
        ])
    }
    
    final func setupButtonListView() {
        contentView.addSubview(buttonListView)
        
        NSLayoutConstraint.activate([
            buttonListView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            buttonListView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: buttonListViewXMargin
            ),
            buttonListView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -(buttonListViewXMargin)
            ),
            buttonListView.topAnchor.constraint(
                equalTo: titleView.bottomAnchor,
                constant: HelpCenterChatButtonListCell.buttonListViewTopMargin
            )
        ])
    }
}

// MARK: - Configure
extension HelpCenterChatButtonListCell {
    final func configure(item: HelpCenterResponseModel) {
        if case let .buttons(buttons) = item.content {
            titleView.configure(title: buttons.text)
            buttonListView.configure(buttonList: buttons)
        }
    }
}

// MARK: - HelpCenterChatButtonListContentViewDelegate
extension HelpCenterChatButtonListCell: HelpCenterChatButtonListContentViewDelegate {
    func helpOptionsButtonListView(didTapButton button: HelpCenterContentButtonModel) {
        delegate?.helpCenterChatButtonListCell(didTapButton: button)
    }
}
