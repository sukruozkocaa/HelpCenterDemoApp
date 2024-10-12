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
    func showInProgressTodos()
    
    func showInProgressTodosLoading()
    
    func hideInProgressTodosLoading()
    
    func showCompletedTodos()
    
    func showCompletedTodosLoading()
    
    func hideCompletedTodosLoading()
    
    func showError(error: Error)
}
