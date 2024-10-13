//
//  UIAlertHelper.swift
//  HelpCenterDemoApp
//
//  Created by Şükrü on 13.10.2024.
//

import Foundation
import UIKit

// MARK: - UIAlertHelper
// This class is responsible for displaying UIAlertController in a reusable way across the app.
final class UIAlertHelper {
    
    // Singleton instance of UIAlertHelper, ensures only one instance of the helper is used throughout the app.
    static let shared = UIAlertHelper()
    
    // Private initializer to prevent creating multiple instances of the helper.
    private init() {}
    
    // This function shows an alert with a title, message, and a customizable list of actions.
    // Parameters:
    // - title: The title of the alert.
    // - message: The message body of the alert.
    // - actions: An array of UIAlertActions to be added to the alert.
    // - viewController: The UIViewController where the alert will be presented.
    func showAlert(
        title: String,
        message: String,
        actions: [UIAlertAction],
        in viewController: UIViewController
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { alert.addAction($0) }
        viewController.present(alert, animated: true, completion: nil)
    }
    
    // This function shows a simple alert with just an "OK" button.
    // It calls the showAlert method internally with one action (the "OK" button).
    // Parameters:
    // - title: The title of the alert.
    // - message: The message body of the alert.
    // - viewController: The UIViewController where the alert will be presented.
    func showSimpleAlert(
        title: String,
        message: String,
        in viewController: UIViewController
    ) {
        // Create an "OK" button action.
        let okAction = UIAlertAction(title: "Tamam", style: .default, handler: nil)
        
        // Call the showAlert method with the "OK" action.
        showAlert(title: title, message: message, actions: [okAction], in: viewController)
    }
    
    // This function shows a confirmation alert asking the user if they want to end the conversation.
    // It provides two options: "End" the conversation or "Start New Conversation".
    // Parameters:
    // - viewController: The UIViewController where the alert will be presented.
    // - endAction: Closure to execute if the user chooses to end the conversation.
    // - startNewConversationAction: Closure to execute if the user chooses to start a new conversation.
    func showEndConversationAlert(
        in viewController: UIViewController,
        endAction: @escaping () -> Void,
        startNewConversationAction: @escaping () -> Void
    ) {
        // Create the "End" action with its handler.
        let endAction = UIAlertAction(title: "Sonlandır", style: .default) { _ in
            endAction()
        }
            
        // Create the "Start New Conversation" action with its handler.
        let startNewAction = UIAlertAction(title: "Yeni görüşme başlat", style: .default) { _ in
            startNewConversationAction()
        }
            
        // Create a "Cancel" action.
        let cancelAction = UIAlertAction(title: "İptal", style: .cancel, handler: nil)
            
        // Call showAlert method with all the actions.
        showAlert(
            title: "Canlı Destek",
            message: "Konuşmayı sonlandırmak istiyor musun?",
            actions: [endAction, startNewAction, cancelAction],
            in: viewController
        )
    }
}
