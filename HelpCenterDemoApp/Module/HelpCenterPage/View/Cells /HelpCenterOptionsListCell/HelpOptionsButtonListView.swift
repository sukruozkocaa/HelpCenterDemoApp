//
//  HelpCenterOptionsButtonListCell.swift
//  HelpCenterDemoApp
//
//  Created by Şükrü on 12.10.2024.
//

import UIKit

// MARK: - HelpOptionsButtonListViewDelegate
protocol HelpOptionsButtonListViewDelegate: AnyObject {
    func helpOptionsButtonListView(didTapButton button: HelpCenterContentButtonModel)
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
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = .zero
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cell: HelpCenterOptionsButtonContentCell.self)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    // MARK: - Private Constants
    private let tableViewCornerRadius: CGFloat = 20.0
    private let tableViewBorderWidth: CGFloat = 0.5
    
    // MARK: - Static Constants
    static let cellHeight: CGFloat = 50.0
    
    // MARK: - Delegates
    weak var delegate: HelpOptionsButtonListViewDelegate?
    
    // MARK: - Variables
    private var buttonList: HelpCenterContentModel? = nil
    
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
        return buttonList?.buttons?.count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = buttonList?.buttons?[indexPath.row] else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(for: HelpCenterOptionsButtonContentCell.self, for: indexPath)
        cell.delegate = self
        cell.configure(button: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return HelpOptionsButtonListView.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = buttonList?.buttons?[indexPath.row] else { return }
        delegate?.helpOptionsButtonListView(didTapButton: item)
    }
}

// MARK: - Configure
extension HelpOptionsButtonListView {
    final func configure(buttonList: HelpCenterContentModel) {
        self.buttonList = buttonList
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            buttonListTableView.reloadData()
        }
    }
}

// MARK: - HelpCenterOptionsButtonContentCellDelegate
extension HelpOptionsButtonListView: HelpCenterOptionsButtonContentCellDelegate {
    func helpCenterOptionsButtonContentCell(didTapButton button: HelpCenterContentButtonModel) {
        delegate?.helpOptionsButtonListView(didTapButton: button)
    }
}
