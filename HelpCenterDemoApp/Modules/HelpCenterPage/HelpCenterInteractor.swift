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
    
    // Presenter -> Interactor
    /// Creates a bubble view for user messages
    func createUserSendBubbleView(bubbleMessage: String)
    /// Connects to the WebSocket using the provided URL
    func connectWebSocket(socketURL: String)
    /// Disconnects from the WebSocket
    func disconnectWebSocket()
    /// Sends a message through the WebSocket
    func sendMessage(_ response: HelpCenterResponseModel)
    /// Fetches details for a specific step
    func getHelpCenterStepDetails(stepId: HelpCenterChatStepTypes)
    /// Calculates the height of a cell based on its content
    func calculateCellHeight(_ response: HelpCenterResponseModel) -> CGFloat
    /// Returns the height for the table view header
    func getTableViewHeightForHeader() -> CGFloat
    /// Dequeues a reusable cell based on the response
    func dequeueReusableCell(_ response: HelpCenterResponseModel, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
}

// MARK: - HelpCenterInteractorResponseProtocol
protocol HelpCenterInteractorResponseProtocol {
    // Interactor -> Presenter
    /// Notifies the presenter that the WebSocket is connected
    func didSocketConnected()
    /// Notifies the presenter that the WebSocket is disconnected
    func didSocketDisconnected()
    /// Notifies the presenter of the retrieved step details
    func didGetStepDetails(stepDetails: HelpCenterResponseModel)
    /// Notifies the presenter to show an end conversation alert
    func didShowEndConversationAlert()
}

// MARK: - HelpCenterInteractor
final class HelpCenterInteractor: HelpCenterInteractorProtocol {
    // MARK: - Properties
    var webSocketDelegate: WebSocketInteractorDelegate?
    var presenter: HelpCenterInteractorResponseProtocol?
    
    // MARK: - WebSocket Management
    func connectWebSocket(socketURL: String) {
        // Set the delegate and connect to the WebSocket
        WebSocketManager.shared.delegate = self
        WebSocketManager.shared.connectWebSocket(socketURL: socketURL)
        
        // Notify presenter on successful connection
        presenter?.didSocketConnected()
    }
    
    func disconnectWebSocket() {
        // Disconnect from the WebSocket and reset the delegate
        WebSocketManager.shared.disconnectWebSocket()
        WebSocketManager.shared.delegate = nil
        
        // Notify presenter on disconnection
        presenter?.didSocketDisconnected()
    }
    
    // MARK: - Message Handling
    func sendMessage(_ response: HelpCenterResponseModel) {
        // Sends a message through the WebSocket
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
        presenter?.didGetStepDetails(stepDetails: bubbleData)
    }
    
    // MARK: - Cell Management
    func dequeueReusableCell(_ response: HelpCenterResponseModel, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let type = response.type
        
        switch type {
        case .button:
            // Dequeue a button cell and configure it
            let cell = tableView.dequeueReusableCell(for: HelpCenterChatButtonListCell.self, for: indexPath)
            cell.configure(item: response)
            cell.delegate = self
            return cell
        case .text:
            // Dequeue a text cell and configure it
            let cell = tableView.dequeueReusableCell(for: HelpCenterChatTextCell.self, for: indexPath)
            cell.configure(item: response)
            return cell
        case .image:
            // Dequeue an image cell and configure it
            let cell = tableView.dequeueReusableCell(for: HelpCenterChatImageCell.self, for: indexPath)
            cell.configure(content: response.content)
            return cell
        case .userBubble:
            // Dequeue a user bubble cell and configure it
            let cell = tableView.dequeueReusableCell(for: HelpCenterChatClientBubbleCell.self, for: indexPath)
            cell.configure(content: response.content)
            return cell
        case nil:
            // Default case for nil
            return UITableViewCell()
        }
    }
    
    // MARK: - Height Calculation
    func calculateCellHeight(_ response: HelpCenterResponseModel) -> CGFloat {
        let type = response.type
        
        switch type {
        case .button:
            // Calculate height for button cell
            return calculateButtonCellHeight(response)
        case .text:
            // Calculate height for text cell
            return calculateTextCellHeight(response)
        case .image:
            // Return fixed height for image cell
            return calculateImageCellHeight()
        case .userBubble:
            // Return fixed height for user bubble cell
            return calculateUserBubbleCellHeight()
        case nil:
            return .zero // Return zero for nil case
        }
    }
    
    func getTableViewHeightForHeader() -> CGFloat {
        // Returns zero for the header height
        return .zero
    }
}

// MARK: - WebSocketInteractorDelegate
extension HelpCenterInteractor: WebSocketInteractorDelegate {
    func didReceiveMessage(_ message: HelpCenterResponseModel) {
        // Notify presenter about new messages received via WebSocket
        presenter?.didGetStepDetails(stepDetails: message)
    }
    
    func didFailWithError(_ error: Error) {
        // Handle error if needed (e.g., log or notify the presenter)
    }
}

// MARK: - HelpCenterChatButtonListCellDelegate
extension HelpCenterInteractor: HelpCenterChatButtonListCellDelegate {
    func helpCenterChatButtonListCell(didTapButton button: HelpCenterContentButtonModel) {
        // Handle button tap events from the button list cell
        guard let bubbleMessage = button.label, let stepId = button.action else { return }
        
        if button.action == .end_conversation {
            // Show end conversation alert if applicable
            presenter?.didShowEndConversationAlert()
        } else {
            // Create user bubble and fetch step details
            createUserSendBubbleView(bubbleMessage: bubbleMessage)
            getHelpCenterStepDetails(stepId: stepId)
        }
    }
}

// MARK: - Private Helpers
private extension HelpCenterInteractor {
    func createUserMessageBubbleData(bubbleMessage: String) -> HelpCenterResponseModel {
        // Creates a HelpCenterResponseModel for the user message bubble
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
                // Add height for each button
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
            
            let frameWidth = screenWidth - totalFrame
            // Calculate height based on text size
            cellHeight += text.heightWithConstrainedWidth(
                width: frameWidth,
                font: IconAndTitleView.labelFont
            )
            
            cellHeight += HelpCenterChatTextCell.contentVStackViewItemSpacing +
            HelpCenterChatTextCell.actionButtonHeight
        }
        
        return cellHeight
    }
    
    func calculateImageCellHeight() -> CGFloat {
        // Return a fixed height for image cells
        return 187.0
    }
    
    func calculateUserBubbleCellHeight() -> CGFloat {
        // Return a fixed height for user bubble cells
        return 40.0
    }
}
