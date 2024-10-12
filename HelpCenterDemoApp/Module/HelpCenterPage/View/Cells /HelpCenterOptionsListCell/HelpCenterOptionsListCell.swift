//
//  HelpCenterOptionsListCell.swift
//  HelpCenterDemoApp
//
//  Created by Şükrü on 12.10.2024.
//

import UIKit

// MARK: - HelpCenterOptionsListCellDelegate
protocol HelpCenterOptionsListCellDelegate: AnyObject {
    func helpCenterOptionsListCell(didTapButton button: HelpCenterContentButtonModel)
}

// MARK: - HelpOptionsListCell
final class HelpCenterOptionsListCell: UITableViewCell {

    // MARK: - Views
    private lazy var titleView: HelpCenterOptionsListTitleView = {
        let helpCenterOptionsListTitleView = HelpCenterOptionsListTitleView()
        helpCenterOptionsListTitleView.configure(
            title: "Merhaba, canlı destek hattına hoş geldiniz! Hangi konuda yardım almak istersiniz?"
        )
        return helpCenterOptionsListTitleView
    }()
    
    private lazy var buttonListView: HelpOptionsButtonListView = {
        let helpOptionsButtonListView = HelpOptionsButtonListView()
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
    weak var delegate: HelpCenterOptionsListCellDelegate?
    
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
private extension HelpCenterOptionsListCell {
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
            titleView.heightAnchor.constraint(equalToConstant: HelpCenterOptionsListCell.titleViewHeight),
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
                constant: HelpCenterOptionsListCell.buttonListViewTopMargin
            )
        ])
    }
}

// MARK: - Configure
extension HelpCenterOptionsListCell {
    final func configure(item: HelpCenterResponseModel) {
        let content = item.content
        
        switch content {
        case .text(_): break
        case .buttons(let button):
            titleView.configure(title: button.text ?? "")
            buttonListView.configure(buttonList: button)            
        case nil: break
        }
    }
}

// MARK: - HelpOptionsButtonListViewDelegate
extension HelpCenterOptionsListCell: HelpOptionsButtonListViewDelegate {
    func helpOptionsButtonListView(didTapButton button: HelpCenterContentButtonModel) {
        delegate?.helpCenterOptionsListCell(didTapButton: button)
    }
}
