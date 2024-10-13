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

    /// Removes all items from the data source, clearing the current chat or responses.
    func removeAllItems()
    
    /// Retrieves the current response items from the data source.
    /// - Returns: An array of `HelpCenterResponseModel` representing the responses in the chat.
    func getResponseItems() -> [HelpCenterResponseModel]
    
    /// Notifies the presenter that the view has been loaded, allowing it to perform any necessary setup or data retrieval.
    func viewDidLoad()
    
    /// Removes all items and starts a new chat session, effectively resetting the current conversation.
    func removeAllItemsAndCreateNewChat()
}

// MARK: - HelpCenterInteractorResponseProtocol
protocol HelpCenterInteractorResponseProtocol {
    // Interactor -> Presenter
    
    /// Notifies the presenter that the WebSocket is connected
    func didSocketConnected()
    
    /// Notifies the presenter that the WebSocket is disconnected
    func didSocketDisconnected()
    
    /// Notifies the presenter of the retrieved step details
    func didTableViewReloadData()
    
    /// Notifies the presenter to show an end conversation alert
    func didShowEndConversationAlert()
    
    /// Configures the user interface elements of the view, setting up visual components and layout as needed.
    func configureUI()
    
    /// Registers the necessary cells for the table view, allowing it to dequeue and display them appropriately.
    func configureRegisterCells()
    
    /// Notifies that the table view has scrolled to the bottom, which may trigger actions like loading more content or updating the UI.
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
        response.append(bubbleData)
        presenter?.didTableViewReloadData()
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
        // Return a fixed height for image cells
        return 187.0
    }
    
    func calculateUserBubbleCellHeight() -> CGFloat {
        // Return a fixed height for user bubble cells
        return 40.0
    }
}
