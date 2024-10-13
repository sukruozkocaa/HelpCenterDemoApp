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
    /// Array to hold the response models
    var response: [HelpCenterResponseModel] { get set }
    
    // MARK: - View -> Presenter Methods
    /// Called when the view is loaded.
    func viewDidLoad()
    /// Loads the user interface.
    func loadUI()
    /// Registers table view cells.
    func registerTableViewCells()
    /// Connects to the WebSocket.
    func connectWebSocket()
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
/// The presenter that conforms to HelpCenterPresenterProtocol and handles presentation logic.
final class HelpCenterPresenter: HelpCenterPresenterProtocol {
    // MARK: - Properties
    var view: HelpCenterViewProtocol? // Reference to the view
    var interactor: HelpCenterInteractorProtocol? // Reference to the interactor
    var router: HelpCenterRouterProtocol? // Reference to the router
    var response: [HelpCenterResponseModel] = [] // Array holding Help Center responses

    // MARK: - Lifecycle Methods
    /// Method called when the view is loaded. Sets up UI and interactions.
    func viewDidLoad() {
        loadUI() // Load the user interface
        registerTableViewCells() // Register table view cells
        connectWebSocket() // Establish a WebSocket connection
        interactor?.getHelpCenterStepDetails(stepId: .step1) // Request initial step details
    }
    
    /// Sends a message through the WebSocket.
    func sendSocketMessage(stepId: HelpCenterChatStepTypes) {
        self.interactor?.getHelpCenterStepDetails(stepId: stepId)
    }
    
    /// Connects to the WebSocket.
    func connectWebSocket() {
        interactor?.connectWebSocket(socketURL: "wss://echo.websocket.org")
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
    
    /// Registers the necessary table view cells.
    func registerTableViewCells() {
        view?.registerTableViewCells()
    }
    
    /// Loads the user interface elements.
    func loadUI() {
        view?.loadUI()
    }
    
    /// Sends a user bubble message to the interactor.
    func sendUserBubble(bubbleMessage: String) {
        interactor?.createUserSendBubbleView(bubbleMessage: bubbleMessage)
    }
    
    /// Retrieves the current response data.
    func responseData() -> [HelpCenterResponseModel]? {
        return response
    }
    
    /// Returns the height for the header in the table view.
    func headerHeight() -> CGFloat {
        return interactor?.getTableViewHeightForHeader() ?? .zero
    }
    
    /// Dequeues a reusable cell for the table view.
    func dequeueReusableCell(_ response: HelpCenterResponseModel, tableView: UITableView,  indexPath: IndexPath) -> UITableViewCell {
        guard let cell = interactor?.dequeueReusableCell(response, tableView: tableView, indexPath: indexPath) else { return UITableViewCell() }
        return cell
    }
    
    /// Clears all responses and starts a new conversation.
    func clearResponses() {
        response.removeAll(keepingCapacity: true)
        view?.startNewConversation()
    }
    
    /// Removes the current conversation and disconnects the WebSocket.
    func removeConversation() {
        interactor?.disconnectWebSocket()
        response.removeAll()
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
    func didGetStepDetails(stepDetails: HelpCenterResponseModel) {
        response.append(stepDetails)
        view?.displayMessage(stepDetails)
    }
    
    /// Called when the socket connection is established.
    func didSocketConnected() {
        print("Socket Connected")
    }
    
    /// Called when the socket connection is closed.
    func didSocketDisconnected() {
        print("Socket Disconnected")
    }
}
