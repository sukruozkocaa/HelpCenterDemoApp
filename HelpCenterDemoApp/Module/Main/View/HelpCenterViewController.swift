//
//  HelpCenterViewController.swift
//  HelpCenterDemoApp
//
//  Created by Şükrü on 12.10.2024.
//

import UIKit

// MARK: - HelpCenterViewController
final class HelpCenterViewController: UIViewController {

    // MARK: - Public Variables
    var presenter: HelpCenterPresenterProtocol?
    
    // MARK: - Views
    private lazy var chatContentTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cell: HelpCenterOptionsListCell.self)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
    }
}

// MARK: - Setup UI
private extension HelpCenterViewController {
    final func setupUI() {
        setupViewUI()
        setupChatContentTableView()
    }
    
    final func setupViewUI() {
        view.backgroundColor = .white
    }
    
    final func setupChatContentTableView() {
        view.addSubview(chatContentTableView)
        
        // TODO: - Create UIView fill superview extension.
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            chatContentTableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            chatContentTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            chatContentTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            chatContentTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
}

// MARK: - UITableViewDelegate
extension HelpCenterViewController: UITableViewDelegate {}

// MARK: - UITableViewDataSource
extension HelpCenterViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: HelpCenterOptionsListCell.self, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 216.0
    }
}

// MARK: - HelpCenterViewProtocol
extension HelpCenterViewController: HelpCenterViewProtocol {
    func showInProgressTodos() {
        
    }
    
    func showInProgressTodosLoading() {
        
    }
    
    func hideInProgressTodosLoading() {
        
    }
    
    func showCompletedTodos() {
        
    }
    
    func showCompletedTodosLoading() {
        
    }
    
    func hideCompletedTodosLoading() {
        
    }
    
    func showError(error: Error) {
        
    }
}
