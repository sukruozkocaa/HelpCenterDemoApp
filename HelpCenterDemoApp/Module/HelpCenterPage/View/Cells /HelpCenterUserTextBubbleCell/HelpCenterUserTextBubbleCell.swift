//
//  HelpCenterUserTextBubbleCell.swift
//  HelpCenterDemoApp
//
//  Created by Şükrü on 12.10.2024.
//

import UIKit

// MARK: - HelpCenterUserTextBubbleCell
final class HelpCenterUserTextBubbleCell: UITableViewCell {

    // MARK: - Views
    private lazy var bubbleView: HelpCenterUserTextBubbleView = {
        let helpCenterUserTextBubbleView = HelpCenterUserTextBubbleView()
        return helpCenterUserTextBubbleView
    }()
    
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
private extension HelpCenterUserTextBubbleCell {
    final func setupUI() {
        setupViewUI()
        setupBubbleView()
    }
    
    final func setupViewUI() {
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    final func setupBubbleView() {
        addSubview(bubbleView)
        
        NSLayoutConstraint.activate([
            bubbleView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bubbleView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bubbleView.topAnchor.constraint(equalTo: topAnchor),
            bubbleView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: - Extension
extension HelpCenterUserTextBubbleCell {
    final func configure(content: ContentType?) {
        switch content {
        case .text(let bubbleMessage):
            bubbleView.configure(bubbleMessage: bubbleMessage)
        case .buttons(_):
            break
        case .none:
            break
        }
    }
}
