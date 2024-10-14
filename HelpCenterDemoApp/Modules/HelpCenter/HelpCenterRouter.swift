//
//  HelpCenterRouterProtocol.swift
//  HelpCenterDemoApp
//
//  Created by Şükrü on 12.10.2024.
//

import Foundation
import UIKit

// MARK: - HelpCenterRouterProtocol
protocol HelpCenterRouterProtocol: AnyObject {
    // Present -> Router
    func createModule() -> UINavigationController
}

// MARK: - HelpCenterRouter
final class HelpCenterRouter: HelpCenterRouterProtocol {
    func createModule() -> UINavigationController {
        let view = HelpCenterViewController()
        let presenter: HelpCenterPresenterProtocol & HelpCenterInteractorResponseProtocol = HelpCenterPresenter()
        var interactor: HelpCenterInteractorProtocol = HelpCenterInteractor()
        let router: HelpCenterRouterProtocol = HelpCenterRouter()
        
        view.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        interactor.presenter = presenter
                        
        let navController = UINavigationController(rootViewController: view)
        return navController
    }
}
