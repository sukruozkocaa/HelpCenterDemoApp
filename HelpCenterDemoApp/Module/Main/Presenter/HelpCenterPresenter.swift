//
//  HelpCenterPresenterProtocol.swift
//  HelpCenterDemoApp
//
//  Created by Şükrü on 12.10.2024.
//

import Foundation

// MARK: - HelpCenterPresenterProtocol
protocol HelpCenterPresenterProtocol: AnyObject {
    var view: HelpCenterViewProtocol? { get set }
    var interactor: HelpCenterInteractorProtocol? { get set }
    var router: HelpCenterRouterProtocol? { get set }
    
    // View -> Presenter
    func viewDidLoad()
    func getInProgressTodos()
    func createTodoCreateModule(from view: HelpCenterViewProtocol)
    func showTodoDetails(from view: HelpCenterViewProtocol)
}

// MARK: - HelpCenterPresenter
final class HelpCenterPresenter: HelpCenterPresenterProtocol {
    
    // MARK: - Base
    var view: HelpCenterViewProtocol?
    var interactor: HelpCenterInteractorProtocol?
    var router: HelpCenterRouterProtocol?

    func viewDidLoad() {
        
    }
    
    func getInProgressTodos() {
        
    }
    
    func createTodoCreateModule(from view: HelpCenterViewProtocol) {
        
    }
    
    func showTodoDetails(from view: HelpCenterViewProtocol) {
        
    }
}

// MARK: -
extension HelpCenterPresenter: HelpCenterInteractorResponseProtocol {
    func didGetCompletedTodos() {
        
    }
    
    func didGeInProgressTodos() {
        
    }
    
    func onError(_ error: Error) {
        
    }
}
