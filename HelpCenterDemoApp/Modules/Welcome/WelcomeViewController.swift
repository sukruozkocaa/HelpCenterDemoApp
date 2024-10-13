//
//  WelcomeViewController.swift
//  HelpCenterDemoApp
//
//  Created by Şükrü on 13.10.2024.
//

import UIKit

// MARK: - WelcomeViewController
final class WelcomeViewController: UIViewController {

    // MARK: - Views
    private lazy var actionButton: UIButton = {
        let button = UIButton()
        button.setTitle("DEVAM", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(actionButton)
        
        NSLayoutConstraint.activate([
            actionButton.heightAnchor.constraint(equalToConstant: 50.0),
            actionButton.widthAnchor.constraint(equalToConstant: 200.0),
            actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            actionButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
