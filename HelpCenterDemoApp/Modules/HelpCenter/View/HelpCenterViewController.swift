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
    private lazy var navigationBarContentView: HelpCenterNavigationBarContentView = {
        let helpCenterNavigationContentView = HelpCenterNavigationBarContentView()
        return helpCenterNavigationContentView
    }()
    
    private lazy var chatContentTableView: UITableView = {
        let tableView = UITableView(
            frame: .zero,
            style: .grouped
        )
        tableView.contentInset.top = tableViewInset
        tableView.contentInset.bottom = tableViewInset
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Public Variables
    var presenter: HelpCenterPresenterProtocol?
        
    // MARK: - Private Constants
    private let tableViewInset: CGFloat = 30.0
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
    deinit {
        presenter?.disconnectWebSocket()
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
        navigationItem.titleView = navigationBarContentView
    }
    
    final func setupChatContentTableView() {
        view.addSubview(chatContentTableView)
        
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
        guard let responseItems = presenter?.responseData() else { return .zero }
        return responseItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let responseItems = presenter?.responseData() else { return UITableViewCell() }
        let item = responseItems[indexPath.section]
        guard let cell = presenter?.dequeueReusableCell(item, tableView: tableView, indexPath: indexPath) else {
            return UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let responseItems = presenter?.responseData() else { return .zero }

        let height = presenter?.calculateCellHeight(response: responseItems[indexPath.section])
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

    func socketConnectionStatus(isConnected: Bool) {
        navigationBarContentView.configure(isConnectWebSocket: isConnected)
    }
    
    func reloadTableView() {
        chatContentTableView.reloadTableView()
    }
    
    func scrollToBottomTableView() {
        chatContentTableView.scrollToBottom()
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

// MARK: - HelpCenterChatTextCellDelegate
extension HelpCenterViewController: HelpCenterChatTextCellDelegate {
    func helpCenterChatTextCell(didTapEndConversation cell: HelpCenterChatTextCell) {
        self.showEndConversationAlert()
    }
}
