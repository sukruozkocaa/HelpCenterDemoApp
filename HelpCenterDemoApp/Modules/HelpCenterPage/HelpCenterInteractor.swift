//
//  HelpCenterInteractorProtocol.swift
//  HelpCenterDemoApp
//
//  Created by Şükrü on 12.10.2024.
//

import Foundation
import UIKit

// MARK: - HelpCenterInteractorProtocol
protocol HelpCenterInteractorProtocol {
    var presenter: HelpCenterInteractorResponseProtocol? { get set }
    var interactor: HelpCenterInteractorProtocol? { get set }
    var webSocketDelegate: WebSocketInteractorDelegate? { get set }
    
    // Presenter -> Interactor
    func createUserSendBubbleView(bubbleMessage: String)
    func connectWebSocket(socketURL: String)
    func disconnectWebSocket()
    func sendMessage(_ response: HelpCenterResponseModel)
    func getHelpCenterStepDetails(stepId: HelpCenterChatStepTypes)
    func calculateCellHeight(_ response: HelpCenterResponseModel) -> CGFloat
    func dequeueReusableCell(_ response: HelpCenterResponseModel, tableView: UITableView,  indexPath: IndexPath) -> UITableViewCell
}

// MARK: - HelpCenterInteractorResponseProtocol
protocol HelpCenterInteractorResponseProtocol {
    // Interactor -> Presenter
    func didSocketConnected()
    func didSocketDisconnected()
    func didGetStepDetails(stepDetails: HelpCenterResponseModel)
    func didShowEndConversationAlert()
}

// MARK: - HelpCenterInteractorProtocol
final class HelpCenterInteractor: HelpCenterInteractorProtocol {
    var webSocketDelegate: WebSocketInteractorDelegate?
    var interactor: HelpCenterInteractorProtocol?
    var presenter: HelpCenterInteractorResponseProtocol?
    
    func disconnectWebSocket() {
        WebSocketManager.shared.disconnectWebSocket()
        WebSocketManager.shared.delegate = nil
        presenter?.didSocketDisconnected()
    }
    
    func connectWebSocket(socketURL: String) {
        WebSocketManager.shared.delegate = self
        WebSocketManager.shared.connectWebSocket(socketURL: socketURL)
        presenter?.didSocketConnected()
    }
        
    func sendMessage(_ response: HelpCenterResponseModel) {
        WebSocketManager.shared.sendMessage(response)
    }
    
    func getHelpCenterStepDetails(stepId: HelpCenterChatStepTypes) {
        guard let stepDetails = HelpCenterStepManager.shared.createStepDetails(stepId: stepId) else { return }
        WebSocketManager.shared.sendMessage(stepDetails)
    }
    
    func calculateCellHeight(_ response: HelpCenterResponseModel) -> CGFloat {
        return calculateCellHeight(response: response)
    }
    
    func createUserSendBubbleView(bubbleMessage: String) {
        let bubbleData = createUserMessageBubbleData(bubbleMessage: bubbleMessage)
        presenter?.didGetStepDetails(stepDetails: bubbleData)
    }
    
    func dequeueReusableCell(_ response: HelpCenterResponseModel, tableView: UITableView,  indexPath: IndexPath) -> UITableViewCell {
        let data = response
        let type = response.type

        switch type {
        case .button:
            let cell = tableView.dequeueReusableCell(for: HelpCenterChatButtonListCell.self, for: indexPath)
            cell.configure(item: data)
            cell.delegate = self
            return cell
        case .text:
            let cell = tableView.dequeueReusableCell(for: HelpCenterChatTextCell.self, for: indexPath)
            cell.configure(item: data)
            return cell
        case .image:
            let cell = tableView.dequeueReusableCell(for: HelpCenterChatImageCell.self, for: indexPath)
            cell.configure(content: data.content)
            return cell
        case .userBubble:
            let cell = tableView.dequeueReusableCell(for: HelpCenterChatClientBubbleCell.self, for: indexPath)
            cell.configure(content: data.content)
            return cell
        case nil:
            return UITableViewCell()
        }
    }
}

// MARK: - WebSocketInteractorDelegate
extension HelpCenterInteractor: WebSocketInteractorDelegate {
    func didReceiveMessage(_ message: HelpCenterResponseModel) {
        presenter?.didGetStepDetails(stepDetails: message)
    }
    
    func didFailWithError(_ error: Error) {
        
    }
}

// MARK: - HelpCenterOptionsListCellDelegate
extension HelpCenterInteractor: HelpCenterChatButtonListCellDelegate {
    func helpCenterChatButtonListCell(didTapButton button: HelpCenterContentButtonModel) {
        guard let bubbleMessage = button.label,
              let stepId = button.action else { return }
        
        guard button.action != .end_conversation else {
            presenter?.didShowEndConversationAlert()
            return
        }
        
        createUserSendBubbleView(bubbleMessage: bubbleMessage)
        getHelpCenterStepDetails(stepId: stepId)
    }
}

// MARK: - Helpers
private extension HelpCenterInteractor {
    final func calculateCellHeight(response: HelpCenterResponseModel) -> CGFloat {
        let type = response.type
        
        switch type {
        case .button:
            return calculateButtonCellHeight(response)
        case .text:
            return calculateTextCellHeight(response)
        case .image:
            return calculateImageCellHeight()
        case .userBubble:
            return calculateUserBubbleCellHeight()
        case nil:
            return .zero
        }
    }
    
    final func createUserMessageBubbleData(bubbleMessage: String) -> HelpCenterResponseModel {
        let bubbleData = HelpCenterResponseModel(
            step: .await_user_choice,
            type: .userBubble,
            content: .text(bubbleMessage),
            action: .await_user_choice
        )
        
        return bubbleData
    }
}

// MARK: - Cell Height Calculation Methods
private extension HelpCenterInteractor {
    func calculateButtonCellHeight(_ response: HelpCenterResponseModel) -> CGFloat {
        var cellHeight: CGFloat = HelpCenterChatButtonListCell.titleViewHeight +
        HelpCenterChatButtonListCell.buttonListViewTopMargin
        
        if case let .buttons(buttons) = response.content {
            buttons.buttons?.forEach { _ in
                cellHeight += HelpCenterChatButtonListContentView.cellHeight
            }
        }
        
        return cellHeight
    }
    
    func calculateTextCellHeight(_ response: HelpCenterResponseModel) -> CGFloat {
        var cellHeight: CGFloat = IconAndTitleView.contentHStackViewTopMargin
        let screenWidth: CGFloat = UIScreen.main.bounds.width
        
        if case let .text(text) = response.content {
            let totalFrame = (HelpCenterChatTextCell.contentVStackViewXMargin * 2) +
            (IconAndTitleView.contentHStackViewXMargin * 2) +
            (IconAndTitleView.contentHStackViewItemSpacing) +
            (IconAndTitleView.iconImageViewFrame)
            
            let frameWidth = screenWidth - totalFrame
            cellHeight += text.heightWithConstrainedWidth(width: frameWidth,
                                                          font: .systemFont(ofSize: 13.0, weight: .semibold))
            cellHeight += HelpCenterChatTextCell.contentVStackViewItemSpacing +
            HelpCenterChatTextCell.actionButtonHeight
        }
        
        return cellHeight
    }
    
    func calculateImageCellHeight() -> CGFloat {
        return 187.0
    }
    
    func calculateUserBubbleCellHeight() -> CGFloat {
        return 40.0
    }
}
