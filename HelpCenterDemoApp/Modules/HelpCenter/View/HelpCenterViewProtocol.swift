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
    func loadUI()
    func registerTableViewCells()
    func showEndConversationAlert()
    func socketConnectionStatus(isConnected: Bool)
    func reloadTableView()    
    func scrollToBottomTableView()
}
