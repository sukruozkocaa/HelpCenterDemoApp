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
    func displayMessage(_ message: HelpCenterResponseModel)
    func loadUI()
    func registerTableViewCells()
    func showEndConversationAlert()
    func startNewConversation()
    func socketConnectionStatus(isConnected: Bool)
}
