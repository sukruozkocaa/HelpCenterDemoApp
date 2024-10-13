//
//  HelpCenterViewProtocol.swift
//  HelpCenterDemoApp
//
//  Created by Şükrü on 12.10.2024.
//

import Foundation

// MARK: - HelpCenterViewProtocol
protocol HelpCenterViewProtocol: AnyObject {
    var presenter: HelpCenterPresenterProtocol? { get set }
    
    // Presenter -> View    
    /// Loads the initial user interface components and setup.
    func loadUI()
    
    /// Registers the table view cells to be used in the table view.
    func registerTableViewCells()
    
    /// Displays an alert to confirm ending the conversation.
    func showEndConversationAlert()
    
    /// Updates the UI based on the WebSocket connection status.
    /// - Parameter isConnected: A boolean indicating whether the WebSocket is connected.
    func socketConnectionStatus(isConnected: Bool)
    
    /// Reloads the data in the table view to reflect any updates.
    func reloadTableView()
    
    /// Scrolls the table view to the bottom, usually after new messages are added.
    func scrollToBottomTableView()
}
