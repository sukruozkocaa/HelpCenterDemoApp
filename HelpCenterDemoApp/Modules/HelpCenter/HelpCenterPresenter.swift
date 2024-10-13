//
//  HelpCenterPresenterProtocol.swift
//  HelpCenterDemoApp
//
//  Created by Şükrü on 12.10.2024.
//

import Foundation
import UIKit

// MARK: - HelpCenterPresenterProtocol
/// Protocol defining the methods for the Help Center Presenter.
protocol HelpCenterPresenterProtocol: AnyObject {
    /// Reference to the View
    var view: HelpCenterViewProtocol? { get set }
    
    /// Reference to the Interactor
    var interactor: HelpCenterInteractorProtocol? { get set }
    
    /// Reference to the Router
    var router: HelpCenterRouterProtocol? { get set }
    
    // MARK: - View -> Presenter Methods
    
    /// Called when the view is loaded.
    func viewDidLoad()
    
    /// Disconnects from the WebSocket.
    func disconnectWebSocket()
    
    /// Sends a message through the WebSocket.
    func sendSocketMessage(stepId: HelpCenterChatStepTypes)
    
    /// Sends a user bubble message.
    func sendUserBubble(bubbleMessage: String)
    
    /// Clears all responses.
    func clearResponses()
    
    /// Removes the current conversation.
    func removeConversation()
    
    /// Returns the height for the header in the table view.
    func headerHeight() -> CGFloat
    
    /// Retrieves response data.
    func responseData() -> [HelpCenterResponseModel]?
    
    /// Calculates the cell height for a given response.
    func calculateCellHeight(response: HelpCenterResponseModel) -> CGFloat
   
    /// Dequeues a reusable cell for the table view.
    func dequeueReusableCell(_ response: HelpCenterResponseModel, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
}

// MARK: - HelpCenterPresenter
final class HelpCenterPresenter: HelpCenterPresenterProtocol {
    // MARK: - Properties
    
    // Reference to the view
    var view: HelpCenterViewProtocol?
    // Reference to the interactor
    var interactor: HelpCenterInteractorProtocol?
    // Reference to the router
    var router: HelpCenterRouterProtocol?

    // MARK: - Lifecycle Methods
    /// Method called when the view is loaded. Sets up UI and interactions.
    func viewDidLoad() {
        interactor?.viewDidLoad()
    }
    
    /// Sends a message through the WebSocket.
    func sendSocketMessage(stepId: HelpCenterChatStepTypes) {
        interactor?.getHelpCenterStepDetails(stepId: stepId)
    }
    
    /// Disconnects from the WebSocket.
    func disconnectWebSocket() {
        interactor?.disconnectWebSocket()
    }
    
    /// Calculates the height for a given response cell.
    func calculateCellHeight(response: HelpCenterResponseModel) -> CGFloat {
        guard let height = interactor?.calculateCellHeight(response) else { return .zero }
        return height
    }
    
    /// Sends a user bubble message to the interactor.
    func sendUserBubble(bubbleMessage: String) {
        interactor?.createUserSendBubbleView(bubbleMessage: bubbleMessage)
    }
    
    /// Retrieves the current response data.
    func responseData() -> [HelpCenterResponseModel]? {
        let responseData = interactor?.getResponseItems()
        return responseData
    }
    
    /// Returns the height for the header in the table view.
    func headerHeight() -> CGFloat {
        let haderHeight = interactor?.getTableViewHeightForHeader() ?? .zero
        return haderHeight
    }
    
    /// Dequeues a reusable cell for the table view.
    func dequeueReusableCell(_ response: HelpCenterResponseModel, tableView: UITableView,  indexPath: IndexPath) -> UITableViewCell {
        guard let cell = interactor?.dequeueReusableCell(response, tableView: tableView, indexPath: indexPath) else { return UITableViewCell() }
        return cell
    }
    
    /// Clears all responses and starts a new conversation.
    func clearResponses() {
        interactor?.removeAllItemsAndCreateNewChat()
    }
    
    /// Removes the current conversation and disconnects the WebSocket.
    func removeConversation() {
        interactor?.disconnectWebSocket()
        interactor?.removeAllItems()
    }
}

// MARK: - HelpCenterInteractorResponseProtocol
/// Extension to handle responses from the interactor.
extension HelpCenterPresenter: HelpCenterInteractorResponseProtocol {

    /// Displays an alert when the conversation ends.
    func didShowEndConversationAlert() {
        view?.showEndConversationAlert()
    }
    
    /// Handles the received step details and updates the response.
    func didTableViewReloadData() {
        view?.reloadTableView()
    }
    
    /// Called when the socket connection is established.
    func didSocketConnected() {
        view?.socketConnectionStatus(isConnected: true)
        print("Socket Connected")
    }
    
    /// Called when the socket connection is closed.
    func didSocketDisconnected() {
        view?.socketConnectionStatus(isConnected: false)
        print("Socket Disconnected")
    }
    
    /// Loads the user interface elements.
    func configureUI() {
        view?.loadUI()
    }
    
    /// Registers the necessary table view cells.
    func configureRegisterCells() {
        view?.registerTableViewCells()
    }
    
    /// Scroll To Bottom table view.
    func didTableViewScrollToBottom() {
        view?.scrollToBottomTableView()
    }
    
    func didShowErrorMessage(error: Error) {
        print("\(error.localizedDescription)")
    }
}
