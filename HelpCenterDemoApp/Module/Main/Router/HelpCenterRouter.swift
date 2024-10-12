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
// The HelpCenterRouter class responsible for setting up the VIPER module and routing
final class HelpCenterRouter: HelpCenterRouterProtocol {
    
    // Function to create the Help Center module and return a UINavigationController containing it
    func createModule() -> UINavigationController {
        
        // Initialize the HelpCenterViewController, which will act as the view in the VIPER architecture
        let view = HelpCenterViewController()
        
        // Initialize the presenter, which conforms to both HelpCenterPresenterProtocol and HelpCenterInteractorResponseProtocol.
        // This presenter will handle business logic and interact with the view and interactor.
        let presenter: HelpCenterPresenterProtocol & HelpCenterInteractorResponseProtocol = HelpCenterPresenter()
        
        // Initialize the interactor, which will handle data-related tasks (fetching, processing, etc.).
        // It will communicate with the presenter to relay data.
        var interactor: HelpCenterInteractorProtocol = HelpCenterInteractor()
        
        // Initialize the router, responsible for handling navigation and routing between views.
        let router: HelpCenterRouterProtocol = HelpCenterRouter()
        
        // Set up the connections between the VIPER components.
        // The view's presenter is assigned to handle UI updates and logic.
        view.presenter = presenter
        
        // The presenter knows about the view to communicate UI-related changes.
        presenter.view = view
        
        // The presenter knows about the interactor to manage the business logic and request data.
        presenter.interactor = interactor
        
        // The presenter knows about the router to handle navigation logic.
        presenter.router = router
        
        // The interactor communicates with the presenter to return data and results.
        interactor.presenter = presenter
        
        // Set the view's title, which will be displayed in the navigation bar
        view.title = "Canlı Destek Merkezi"
        
        // Create a UINavigationController with the view as its rootViewController.
        // This allows for navigation features like back and forth navigation.
        let navController = UINavigationController(rootViewController: view)
        
        // Return the navigation controller containing the view.
        return navController
    }
}
