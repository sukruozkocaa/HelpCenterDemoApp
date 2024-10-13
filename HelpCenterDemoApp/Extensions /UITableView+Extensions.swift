//
//  UITableView+Extensions.swift
//  HelpCenterDemoApp
//
//  Created by Şükrü on 12.10.2024.
//

import UIKit

// MARK: - UITableView Extensions 
extension UITableView {
    
    // MARK: - Reuse Identifier Helpers
    // Private method to generate a reuse identifier based on the type of cell or header/footer view.
    // 'type': The type of the UITableViewCell or UITableViewHeaderFooterView.
    private func reuseIndentifier<T>(for type: T.Type) -> String {
        // Returns a string representation of the type.
        return String(describing: type)
    }

    // Registers a UITableViewCell type for reuse in the table view.
    // 'cell': The UITableViewCell type to be registered.
    public func register<T: UITableViewCell>(cell: T.Type) {
        // Registers the cell with its reuse identifier.
        register(T.self, forCellReuseIdentifier: reuseIndentifier(for: cell))
    }

    // Registers a UITableViewHeaderFooterView type for reuse in the table view.
    // 'headerFooterView': The UITableViewHeaderFooterView type to be registered.
    public func register<T: UITableViewHeaderFooterView>(headerFooterView: T.Type) {
        // Registers the header/footer view with its reuse identifier.
        register(T.self, forHeaderFooterViewReuseIdentifier: reuseIndentifier(for: headerFooterView))
    }

    // Dequeues a reusable UITableViewCell for the given type and indexPath.
    // 'type': The UITableViewCell type to dequeue.
    // 'indexPath': The indexPath where the cell is dequeued.
    // Returns a typed UITableViewCell.
    public func dequeueReusableCell<T: UITableViewCell>(for type: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: reuseIndentifier(for: type), for: indexPath) as? T else {
            // If dequeuing fails, it throws a fatal error.
            fatalError("Failed to dequeue cell.")
        }
        return cell
    }

    // Dequeues a reusable UITableViewHeaderFooterView for the given type.
    // 'type': The UITableViewHeaderFooterView type to dequeue.
    // Returns a typed UITableViewHeaderFooterView.
    public func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(for type: T.Type) -> T {
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: reuseIndentifier(for: type)) as? T else {
            // If dequeuing fails, it throws a fatal error.
            fatalError("Failed to dequeue footer view.")
        }
        return view
    }

    // MARK: - Scrolling Helpers
    // Scrolls the table view to the bottom-most row in the last section.
    // Uses main dispatch queue to ensure the UI is updated on the main thread.
    func scrollToBottom() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            let indexPath = IndexPath(
                row: self.numberOfRows(inSection:  self.numberOfSections - 1) - 1,
                section: self.numberOfSections - 1
            )
            
            // Check if the indexPath exists before scrolling.
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                // Scrolls to the bottom row.
                self.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }

    // Scrolls the table view to the top-most row in the first section.
    // Uses main dispatch queue to ensure the UI is updated on the main thread.
    func scrollToTop() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            let indexPath = IndexPath(row: .zero, section: .zero)
            
            // Check if the indexPath exists before scrolling.
            if hasRowAtIndexPath(indexPath: indexPath) {
                // Scrolls to the top row.
                self.scrollToRow(at: indexPath, at: .top, animated: false)
           }
        }
    }

    // MARK: - Helper Method to Check Row Availability
    // Checks whether a specific indexPath is valid, i.e., whether it corresponds to an existing section and row in the table view.
    // 'indexPath': The indexPath to check for validity.
    // Returns true if the row exists, false otherwise.
    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }

    // MARK: - Reloading Table View
    // Reloads the table view's data on the main thread.
    func reloadTableView() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            // Triggers reload of table view data.
            self.reloadData()
        }
    }
}
