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
    var webSocketDelegate: WebSocketInteractorDelegate? { get set }
    var response: [HelpCenterResponseModel] { get set }

    // Presenter -> Interactor
    func createUserSendBubbleView(bubbleMessage: String)
    func connectWebSocket(socketURL: String)
    func disconnectWebSocket()
    func sendMessage(_ response: HelpCenterResponseModel)
    func getHelpCenterStepDetails(stepId: HelpCenterChatStepTypes)
    func calculateCellHeight(_ response: HelpCenterResponseModel) -> CGFloat
    func getTableViewHeightForHeader() -> CGFloat
    func dequeueReusableCell(_ response: HelpCenterResponseModel, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    func removeAllItems()
    func getResponseItems() -> [HelpCenterResponseModel]
    func viewDidLoad()
    func removeAllItemsAndCreateNewChat()
}

// MARK: - HelpCenterInteractorResponseProtocol
protocol HelpCenterInteractorResponseProtocol {
    // Interactor -> Presenter
    func didSocketConnected()
    func didSocketDisconnected()
    func didTableViewReloadData()
    func didShowEndConversationAlert()
    func configureUI()
    func configureRegisterCells()
    func didTableViewScrollToBottom()
    func didShowErrorMessage(error: Error)
}

// MARK: - HelpCenterInteractor
final class HelpCenterInteractor: HelpCenterInteractorProtocol {

    // MARK: - Properties
    var webSocketDelegate: WebSocketInteractorDelegate?
    var presenter: HelpCenterInteractorResponseProtocol?
    var response: [HelpCenterResponseModel] = []

    // MARK: - WebSocket Management
    func connectWebSocket(socketURL: String) {
        WebSocketManager.shared.delegate = self
        WebSocketManager.shared.connectWebSocket(socketURL: socketURL)
        
        presenter?.didSocketConnected()
    }
    
    func disconnectWebSocket() {
        WebSocketManager.shared.disconnectWebSocket()
        WebSocketManager.shared.delegate = nil
        
        presenter?.didSocketDisconnected()
    }
    
    // MARK: - Message Handling
    func sendMessage(_ response: HelpCenterResponseModel) {
        WebSocketManager.shared.sendMessage(response)
    }
    
    func getHelpCenterStepDetails(stepId: HelpCenterChatStepTypes) {
        // Fetches step details and sends it as a message
        guard let stepDetails = HelpCenterStepManager.shared.createStepDetails(stepId: stepId) else { return }
        WebSocketManager.shared.sendMessage(stepDetails)
    }
    
    // MARK: - Bubble Creation
    func createUserSendBubbleView(bubbleMessage: String) {
        // Creates a user message bubble and informs the presenter
        let bubbleData = createUserMessageBubbleData(bubbleMessage: bubbleMessage)
        response.append(bubbleData)
        presenter?.didTableViewReloadData()
    }
    
    // MARK: - Cell Management
    func dequeueReusableCell(_ response: HelpCenterResponseModel, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let type = response.type
        
        switch type {
        case .button:
            let cell = tableView.dequeueReusableCell(for: HelpCenterChatButtonListCell.self, for: indexPath)
            cell.delegate = self
            cell.configure(item: response)
            return cell
        case .text:
            let cell = tableView.dequeueReusableCell(for: HelpCenterChatTextCell.self, for: indexPath)
            cell.delegate = self
            cell.configure(item: response)
            return cell
        case .image:
            let cell = tableView.dequeueReusableCell(for: HelpCenterChatImageCell.self, for: indexPath)
            cell.configure(content: response.content)
            return cell
        case .userBubble:
            let cell = tableView.dequeueReusableCell(for: HelpCenterChatClientBubbleCell.self, for: indexPath)
            cell.configure(content: response.content)
            return cell
        case nil:
            return UITableViewCell()
        }
    }
    
    // MARK: - Height Calculation
    func calculateCellHeight(_ response: HelpCenterResponseModel) -> CGFloat {
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
    
    func getTableViewHeightForHeader() -> CGFloat {
        return .zero
    }
    
    func removeAllItems() {
        response.removeAll()
        presenter?.didTableViewReloadData()
    }
    
    func getResponseItems() -> [HelpCenterResponseModel] {
        return response
    }
    
    func viewDidLoad() {
        presenter?.configureUI()
        presenter?.configureRegisterCells()
        connectWebSocket(socketURL: "wss://echo.websocket.org")
        getHelpCenterStepDetails(stepId: .step1)
    }
    
    func removeAllItemsAndCreateNewChat() {
        removeAllItems()
        getHelpCenterStepDetails(stepId: .step1)
    }
    
}

// MARK: - WebSocketInteractorDelegate
extension HelpCenterInteractor: WebSocketInteractorDelegate {
    func didReceiveMessage(_ message: HelpCenterResponseModel) {
        // Notify presenter about new messages received via WebSocket
        response.append(message)
        presenter?.didTableViewReloadData()
        presenter?.didTableViewScrollToBottom()
    }
    
    func didFailWithError(_ error: Error) {
        presenter?.didShowErrorMessage(error: error)
    }
}

// MARK: - HelpCenterChatButtonListCellDelegate
extension HelpCenterInteractor: HelpCenterChatButtonListCellDelegate {
    func helpCenterChatButtonListCell(didTapButton button: HelpCenterContentButtonModel) {
        guard let bubbleMessage = button.label, let stepId = button.action else { return }
        
        if button.action == .end_conversation {
            presenter?.didShowEndConversationAlert()
        } else {
            createUserSendBubbleView(bubbleMessage: bubbleMessage)
            getHelpCenterStepDetails(stepId: stepId)
        }
    }
}

// MARK: - HelpCenterChatTextCellDelegate
extension HelpCenterInteractor: HelpCenterChatTextCellDelegate {
    func helpCenterChatTextCell(didTapEndConversation cell: HelpCenterChatTextCell) {
        presenter?.didShowEndConversationAlert()
    }
}

// MARK: - Private Helpers
private extension HelpCenterInteractor {
    func createUserMessageBubbleData(bubbleMessage: String) -> HelpCenterResponseModel {
        return HelpCenterResponseModel(
            step: .await_user_choice,
            type: .userBubble,
            content: .text(bubbleMessage),
            action: .await_user_choice,
            isSelected: false
        )
    }
    
    // MARK: - Cell Height Calculation Methods
    func calculateButtonCellHeight(_ response: HelpCenterResponseModel) -> CGFloat {
        // Calculate the height for button cell based on its content
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
        // Calculate the height for text cell based on its content
        var cellHeight: CGFloat = IconAndTitleView.contentHStackViewTopMargin
        let screenWidth: CGFloat = UIScreen.main.bounds.width
        
        if case let .text(text) = response.content {
            let totalFrame = (HelpCenterChatTextCell.contentVStackViewXMargin * 2) +
            (IconAndTitleView.contentHStackViewXMargin * 2) +
            (IconAndTitleView.contentHStackViewItemSpacing) +
            (IconAndTitleView.iconImageViewFrame)
            
            let labelFrameWidth = screenWidth - totalFrame
            
            // Calculate height based on text size
            cellHeight += text.heightWithConstrainedWidth(
                width: labelFrameWidth,
                font: IconAndTitleView.labelFont
            )
            
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
