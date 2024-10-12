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
            style: .plain
        )
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Public Variables
    var presenter: HelpCenterPresenterProtocol?
    
    // MARK: - Private Variables
    private var response: [HelpCenterResponseModel] = []
    
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
        return response.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = response[indexPath.section]
        guard let cell = presenter?.dequeueReusableCell(data, tableView: tableView, indexPath: indexPath) else {
            return UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let data = response[indexPath.section]
        let height = presenter?.calculateCellHeight(response: data)
        return height ?? .zero
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section != .zero else { return .zero}
        return presenter?.heightForHeaderInSection() ?? .zero
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
        self.response.append(message)
        chatContentTableView.reloadTableView()
        chatContentTableView.scrollToBottom()
    }
    
    func registerTableViewCells() {
        chatContentTableView.register(cell: HelpCenterOptionsListCell.self)
        chatContentTableView.register(cell: HelpCenterImageCell.self)
        chatContentTableView.register(cell: HelpCenterInfoCell.self)
        chatContentTableView.register(cell: HelpCenterUserTextBubbleCell.self)
    }
}

// MARK: - HelpCenterOptionsListCellDelegate
extension HelpCenterViewController: HelpCenterOptionsListCellDelegate {
    func helpCenterOptionsListCell(didTapButton button: HelpCenterContentButtonModel) {
        guard let stepId = button.action,
                let bubbleMessage = button.label else { return }
        
        presenter?.createUserSendBubble(bubbleMessage: bubbleMessage)
        presenter?.sendSocketMessage(stepId: stepId)
    }
}
