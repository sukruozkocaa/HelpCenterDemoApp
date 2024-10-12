//
//  HelpCenterOptionsButtonListCell.swift
//  HelpCenterDemoApp
//
//  Created by Şükrü on 12.10.2024.
//

import UIKit

// MARK: - HelpOptionsButtonListViewDelegate
protocol HelpOptionsButtonListViewDelegate: AnyObject {
    func helpOptionsButtonListView(didTapButton view: HelpOptionsButtonListView)
}

// MARK: - HelpCenterOptionsButtonListCell
final class HelpOptionsButtonListView: UIView {

    // MARK: - Views
    private lazy var buttonListTableView: UITableView = {
        let tableView = UITableView()
        tableView.cornerRadius = tableViewCornerRadius
        tableView.setBorder(
            borderWidth: tableViewBorderWidth,
            borderColor: .init(hexString: "D1D1D1")
        )
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cell: HelpCenterOptionsButtonContentCell.self)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    // MARK: - Constants
    private let tableViewCornerRadius: CGFloat = 20.0
    private let tableViewBorderWidth: CGFloat = 0.5
    private let cellHeight: CGFloat = 50.0
    
    // MARK: - Delegates
    weak var delegate: HelpOptionsButtonListViewDelegate?
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Setup UI
private extension HelpOptionsButtonListView {
    final func setupUI() {
        setupViewUI()
        setupButtonListTableView()
    }
    
    final func setupViewUI() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
    }
    
    final func setupButtonListTableView() {
        addSubview(buttonListTableView)
        
        NSLayoutConstraint.activate([
            buttonListTableView.topAnchor.constraint(equalTo: topAnchor),
            buttonListTableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            buttonListTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            buttonListTableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

// MARK: - UITableViewDelegate
extension HelpOptionsButtonListView: UITableViewDelegate {}

// MARK: - UITableViewDataSource
extension HelpOptionsButtonListView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: HelpCenterOptionsButtonContentCell.self, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
}

