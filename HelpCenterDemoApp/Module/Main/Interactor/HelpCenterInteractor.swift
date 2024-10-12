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
    
    // Presenter -> Interactor
    func getCompletedTodos()
    func getInProgressTodos()
}

// MARK: - HelpCenterInteractorResponseProtocol
protocol HelpCenterInteractorResponseProtocol {
    // Interactor -> Presenter
    func didGetCompletedTodos()
    func didGeInProgressTodos()
    func onError(_ error: Error)
}

// MARK: -
final class HelpCenterInteractor: HelpCenterInteractorProtocol {
    var presenter: HelpCenterInteractorResponseProtocol?
    
    func getCompletedTodos() {
        self.presenter?.didGeInProgressTodos()
    }
    
    func getInProgressTodos() {
     
        self.presenter?.didGetCompletedTodos()
    }
}

// TODO: Ekstra şeyler olursa buradan yöneticen
extension HelpCenterInteractor {
    
}
