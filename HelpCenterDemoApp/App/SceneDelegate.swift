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
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let helpCenterVC = HelpCenterRouter().createModule().topViewController!
        let navController = UINavigationController(rootViewController: helpCenterVC)
        let window = UIWindow(windowScene: windowScene)
        
        window.rootViewController = navController
        window.makeKeyAndVisible()
        
        self.window = window
    }
}
