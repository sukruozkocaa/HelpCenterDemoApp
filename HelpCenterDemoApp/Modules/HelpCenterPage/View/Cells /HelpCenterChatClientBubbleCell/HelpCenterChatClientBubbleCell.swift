//
//  HelpCenterChatClientBubbleCell.swift
//  HelpCenterDemoApp
//
//  Created by Şükrü on 12.10.2024.
//

import UIKit

// MARK: - HelpCenterChatClientBubbleCell
final class HelpCenterChatClientBubbleCell: UITableViewCell {

    // MARK: - Views
    private lazy var bubbleView: HelpCenterChatClientBubbleView = {
        let helpCenterUserTextBubbleView = HelpCenterChatClientBubbleView()
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
private extension HelpCenterChatClientBubbleCell {
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
extension HelpCenterChatClientBubbleCell {
    final func configure(content: ContentType?) {
        if case let .text(bubbleMessage) = content {
            bubbleView.configure(bubbleMessage: bubbleMessage)
        }
    }
}
