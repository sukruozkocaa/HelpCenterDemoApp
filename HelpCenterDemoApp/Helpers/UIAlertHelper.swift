//
//  UIAlertHelper.swift
//  HelpCenterDemoApp
//
//  Created by Şükrü on 13.10.2024.
//

import Foundation
import UIKit

// MARK: - UIAlertHelper
final class UIAlertHelper {
    
    static let shared = UIAlertHelper()
    
    private init() {}
    
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
    
    // Parameters:
    // - title: The title of the alert.
    // - message: The message body of the alert.
    // - viewController: The UIViewController where the alert will be presented.
    func showSimpleAlert(
        title: String,
        message: String,
        in viewController: UIViewController
    ) {
        let okAction = UIAlertAction(title: "Tamam", style: .default, handler: nil)
        showAlert(title: title, message: message, actions: [okAction], in: viewController)
    }
    
    // This function shows a confirmation alert asking the user if they want to end the conversation.
    // Parameters:
    // - viewController: The UIViewController where the alert will be presented.
    // - endAction: Closure to execute if the user chooses to end the conversation.
    // - startNewConversationAction: Closure to execute if the user chooses to start a new conversation.
    func showEndConversationAlert(
        in viewController: UIViewController,
        endAction: @escaping () -> Void,
        startNewConversationAction: @escaping () -> Void
    ) {
        let endAction = UIAlertAction(title: "Sonlandır", style: .default) { _ in
            endAction()
        }
            
        let startNewAction = UIAlertAction(title: "Yeni görüşme başlat", style: .default) { _ in
            startNewConversationAction()
        }
            
        let cancelAction = UIAlertAction(title: "İptal", style: .cancel, handler: nil)
            
        showAlert(
            title: "Canlı Destek",
            message: "Konuşmayı sonlandırmak istiyor musun?",
            actions: [endAction, startNewAction, cancelAction],
            in: viewController
        )
    }
}
