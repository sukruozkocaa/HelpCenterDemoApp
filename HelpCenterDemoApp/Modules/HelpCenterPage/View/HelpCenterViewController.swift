//
//  HelpCenterViewController.swift
//  HelpCenterDemoApp
//
//  Created by Şükrü on 12.10.2024.
//

import UIKit

// MARK: - HelpCenterViewController
final class HelpCenterViewController: UIViewController {

    // MARK: - Views
    private lazy var chatContentTableView: UITableView = {
        let tableView = UITableView(
            frame: .zero,
            style: .grouped
        )
        tableView.contentInset.bottom = 30.0
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Public Variables
    var presenter: HelpCenterPresenterProtocol?
        
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
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
        return presenter?.response.count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let data = presenter?.response[indexPath.section],
              let cell = presenter?.dequeueReusableCell(data, tableView: tableView, indexPath: indexPath) else {
            return UITableViewCell()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let data = presenter?.response[indexPath.section] else { return .zero }
        let height = presenter?.calculateCellHeight(response: data)
        
        return height ?? .zero
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section != .zero else { return .zero}
        return presenter?.headerHeight() ?? .zero
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        return headerView
    }
    
}

// MARK: - HelpCenterViewProtocol
extension HelpCenterViewController: HelpCenterViewProtocol {
    func loadUI() {
        setupUI()
    }
    
    func displayMessage(_ message: HelpCenterResponseModel) {
        chatContentTableView.reloadTableView()
        chatContentTableView.scrollToBottom()
    }
    
    func registerTableViewCells() {
        chatContentTableView.register(cell: HelpCenterChatButtonListCell.self)
        chatContentTableView.register(cell: HelpCenterChatImageCell.self)
        chatContentTableView.register(cell: HelpCenterChatTextCell.self)
        chatContentTableView.register(cell: HelpCenterChatClientBubbleCell.self)
    }
    
    func showEndConversationAlert() {
        UIAlertHelper.shared.showEndConversationAlert(in: self) { [weak self] in
            guard let self else { return }
            self.presenter?.removeConversation()
        } startNewConversationAction: { [weak self] in
            guard let self else { return }
            self.presenter?.clearResponses()
        }
    }
    
    func startNewConversation() {
        self.chatContentTableView.reloadTableView()
        self.presenter?.sendSocketMessage(stepId: .step1)
    }
    
}

// MARK: - HelpCenterOptionsListCellDelegate
extension HelpCenterViewController: HelpCenterChatButtonListCellDelegate {
    func helpCenterChatButtonListCell(didTapButton button: HelpCenterContentButtonModel) {
        guard let stepId = button.action,
                let bubbleMessage = button.label else { return }

        presenter?.sendUserBubble(bubbleMessage: bubbleMessage)
        presenter?.sendSocketMessage(stepId: stepId)
    }
}
