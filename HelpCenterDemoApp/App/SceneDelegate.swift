//
//  SceneDelegate.swift
//  HelpCenterDemoApp
//
//  Created by Şükrü on 12.10.2024.
//

import UIKit

// MARK: - SceneDelegate
final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    // Represents the application's main window
    var window: UIWindow?

    // Called when the scene is being connected to the app
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        /// Try to cast the scene to UIWindowScene and return if it fails
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        /// Create a module from HelpCenterRouter and get its top view controller
        let helpCenterVC = HelpCenterRouter().createModule().topViewController!
        
        /// Initialize a UINavigationController with HelpCenterVC as the root view controller
        let navController = UINavigationController(rootViewController: helpCenterVC)
        
        /// Create a new UIWindow and associate it with the windowScene
        let window = UIWindow(windowScene: windowScene)
        
        /// Set the UINavigationController as the rootViewController of the window
        window.rootViewController = navController
        
        /// Make the window key (active) and visible to the user
        window.makeKeyAndVisible()
        
        /// Assign the newly created window to the window property of SceneDelegate
        self.window = window
    }
}
