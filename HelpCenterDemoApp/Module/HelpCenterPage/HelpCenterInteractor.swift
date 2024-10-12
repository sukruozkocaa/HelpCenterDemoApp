//
//  HelpCenterInteractorProtocol.swift
//  HelpCenterDemoApp
//
//  Created by Şükrü on 12.10.2024.
//

import Foundation
import UIKit

// MARK: - HelpCenterInteractorProtocol
protocol HelpCenterInteractorProtocol {
    var presenter: HelpCenterInteractorResponseProtocol? { get set }
    var interactor: HelpCenterInteractorProtocol? { get set }
    var webSocketDelegate: WebSocketInteractorDelegate? { get set }

    // Presenter -> Interactor
    func createUserSendBubbleView(bubbleMessage: String)
    func connectWebSocket(socketURL: String)
    func disconnectWebSocket()
    func sendMessage(_ response: HelpCenterResponseModel)
    func getHelpCenterStepDetails(stepId: HelpCenterStepTypes)
    func calculateCellHeight(_ response: HelpCenterResponseModel) -> CGFloat
    func dequeueReusableCell(_ response: HelpCenterResponseModel, tableView: UITableView,  indexPath: IndexPath) -> UITableViewCell
}

// MARK: - HelpCenterInteractorResponseProtocol
protocol HelpCenterInteractorResponseProtocol {
    // Interactor -> Presenter
    func didSocketConnected()
    func didSocketDisconnected()
    func didGetStepDetails(stepDetails: HelpCenterResponseModel)
}

// MARK: - HelpCenterInteractorProtocol
final class HelpCenterInteractor: HelpCenterInteractorProtocol {
    var webSocketDelegate: WebSocketInteractorDelegate?
    var interactor: HelpCenterInteractorProtocol?
    var presenter: HelpCenterInteractorResponseProtocol?
    
    func disconnectWebSocket() {
        WebSocketManager.shared.disconnectWebSocket()
    }
    
    func connectWebSocket(socketURL: String) {
        WebSocketManager.shared.delegate = self
        WebSocketManager.shared.connectWebSocket(socketURL: socketURL)
    }
        
    func sendMessage(_ response: HelpCenterResponseModel) {
        WebSocketManager.shared.sendMessage(response)
    }
    
    func getHelpCenterStepDetails(stepId: HelpCenterStepTypes) {
        guard let stepDetails = HelpCenterStepManager.shared.createStepDetails(stepId: stepId) else { return }
        WebSocketManager.shared.sendMessage(stepDetails)
    }
    
    func calculateCellHeight(_ response: HelpCenterResponseModel) -> CGFloat {
        return calculateCellHeight(response: response)
    }
    
    func createUserSendBubbleView(bubbleMessage: String) {
        let bubbleData = createUserMessageBubbleData(bubbleMessage: bubbleMessage)
        presenter?.didGetStepDetails(stepDetails: bubbleData)
    }
    
    func dequeueReusableCell(_ response: HelpCenterResponseModel, tableView: UITableView,  indexPath: IndexPath) -> UITableViewCell {
        let data = response
        let type = response.type

        switch type {
        case .button:
            let cell = tableView.dequeueReusableCell(for: HelpCenterOptionsListCell.self, for: indexPath)
            cell.configure(item: data)
            cell.delegate = self
            return cell
        case .text:
            let cell = tableView.dequeueReusableCell(for: HelpCenterInfoCell.self, for: indexPath)
            cell.configure(item: data)
            return cell
        case .image:
            let cell = tableView.dequeueReusableCell(for: HelpCenterImageCell.self, for: indexPath)
            cell.configure(content: data.content)
            return cell
        case .userBubble:
            let cell = tableView.dequeueReusableCell(for: HelpCenterUserTextBubbleCell.self, for: indexPath)
            cell.configure(content: data.content)
            return cell
        case nil:
            return UITableViewCell()
        }
    }
}

// MARK: - WebSocketInteractorDelegate
extension HelpCenterInteractor: WebSocketInteractorDelegate {
    func didReceiveMessage(_ message: HelpCenterResponseModel) {
        presenter?.didGetStepDetails(stepDetails: message)
    }
    
    func didFailWithError(_ error: Error) {
        
    }
}

// MARK: - HelpCenterOptionsListCellDelegate
extension HelpCenterInteractor: HelpCenterOptionsListCellDelegate {
    func helpCenterOptionsListCell(didTapButton button: HelpCenterContentButtonModel) {
        createUserSendBubbleView(bubbleMessage: button.label ?? "")
        getHelpCenterStepDetails(stepId: button.action ?? .step1)
    }
}

// MARK: - Helpers
private extension HelpCenterInteractor {
    final func calculateCellHeight(response: HelpCenterResponseModel) -> CGFloat {
        let type = response.type
        var cellHeight: CGFloat = .zero
        let screenWidth: CGFloat = UIScreen.main.bounds.width
        
        switch type {
        case .button:
            cellHeight = cellHeight + HelpCenterOptionsListCell.titleViewHeight
            cellHeight = cellHeight + HelpCenterOptionsListCell.buttonListViewTopMargin
            
            switch response.content {
            case .buttons(let buttons):
                buttons.buttons?.forEach({ button in
                    cellHeight = cellHeight + HelpOptionsButtonListView.cellHeight
                })
            case .none:
                return .zero
            case .some(.text(_)):
                return .zero
            }
            
            return cellHeight
        case .text:
            cellHeight = cellHeight + HelpCenterInfoIconAndTitleView.contentHStackViewTopMargin

            switch response.content {
            case .text(let text):
                let totalFrame = (HelpCenterInfoCell.contentVStackViewXMargin * 2) +
                (HelpCenterInfoIconAndTitleView.contentHStackViewXMargin * 2) +
                (HelpCenterInfoIconAndTitleView.contentHStackViewItemSpacing) +
                (HelpCenterInfoIconAndTitleView.iconImageViewFrame)
                
                let frame = screenWidth - totalFrame
                
                cellHeight = cellHeight + text.heightWithConstrainedWidth(
                    width: frame,
                    font: .systemFont(ofSize: 13.0, weight: .semibold)
                )

                cellHeight = cellHeight + HelpCenterInfoCell.contentVStackViewItemSpacing
                cellHeight = cellHeight + HelpCenterInfoCell.actionButtonHeight
                return cellHeight
            case .buttons(_):
                return .zero
            case .none:
                break
            }
            return .zero
        case .image:
            return 187.0
        case .userBubble:
            return 40.0
        case nil:
            return .zero
        }
    }
    
    final func createUserMessageBubbleData(bubbleMessage: String) -> HelpCenterResponseModel {
        var bubbleData = HelpCenterResponseModel(
            step: .await_user_choice,
            type: .userBubble,
            content: .text(bubbleMessage),
            action: .await_user_choice
        )
        
        return bubbleData
    }
}
