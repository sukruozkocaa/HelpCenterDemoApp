//
//  HelpCenterPresenterProtocol.swift
//  HelpCenterDemoApp
//
//  Created by Şükrü on 12.10.2024.
//

import Foundation
import UIKit

// MARK: - HelpCenterPresenterProtocol
protocol HelpCenterPresenterProtocol: AnyObject {
    var view: HelpCenterViewProtocol? { get set }
    var interactor: HelpCenterInteractorProtocol? { get set }
    var router: HelpCenterRouterProtocol? { get set }
    
    // MARK: - View -> Presenter Methods
    func viewDidLoad()
    func disconnectWebSocket()
    func sendSocketMessage(stepId: HelpCenterChatStepTypes)
    func sendUserBubble(bubbleMessage: String)
    func clearResponses()
    func removeConversation()
    func headerHeight() -> CGFloat
    func responseData() -> [HelpCenterResponseModel]?
    func calculateCellHeight(response: HelpCenterResponseModel) -> CGFloat
    func dequeueReusableCell(_ response: HelpCenterResponseModel, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
}

// MARK: - HelpCenterPresenter
final class HelpCenterPresenter: HelpCenterPresenterProtocol {

    // MARK: - Properties
    var view: HelpCenterViewProtocol?
    var interactor: HelpCenterInteractorProtocol?
    var router: HelpCenterRouterProtocol?

    // MARK: - Lifecycle Methods
    func viewDidLoad() {
        interactor?.viewDidLoad()
    }
    
    func sendSocketMessage(stepId: HelpCenterChatStepTypes) {
        interactor?.getHelpCenterStepDetails(stepId: stepId)
    }
    
    func disconnectWebSocket() {
        interactor?.disconnectWebSocket()
    }
    
    func calculateCellHeight(response: HelpCenterResponseModel) -> CGFloat {
        guard let height = interactor?.calculateCellHeight(response) else { return .zero }
        return height
    }
    
    func sendUserBubble(bubbleMessage: String) {
        interactor?.createUserSendBubbleView(bubbleMessage: bubbleMessage)
    }
    
    func responseData() -> [HelpCenterResponseModel]? {
        let responseData = interactor?.getResponseItems()
        return responseData
    }
    
    func headerHeight() -> CGFloat {
        let haderHeight = interactor?.getTableViewHeightForHeader() ?? .zero
        return haderHeight
    }
    
    func dequeueReusableCell(_ response: HelpCenterResponseModel, tableView: UITableView,  indexPath: IndexPath) -> UITableViewCell {
        guard let cell = interactor?.dequeueReusableCell(response, tableView: tableView, indexPath: indexPath) else { return UITableViewCell() }
        return cell
    }
    
    func clearResponses() {
        interactor?.removeAllItemsAndCreateNewChat()
    }
    
    func removeConversation() {
        interactor?.disconnectWebSocket()
        interactor?.removeAllItems()
    }
}

// MARK: - HelpCenterInteractorResponseProtocol
extension HelpCenterPresenter: HelpCenterInteractorResponseProtocol {
    func didShowEndConversationAlert() {
        view?.showEndConversationAlert()
    }
    
    func didTableViewReloadData() {
        view?.reloadTableView()
    }
    
    func didSocketConnected() {
        view?.socketConnectionStatus(isConnected: true)
        print("Socket Connected")
    }
    
    func didSocketDisconnected() {
        view?.socketConnectionStatus(isConnected: false)
        print("Socket Disconnected")
    }
    
    func configureUI() {
        view?.loadUI()
    }
    
    func configureRegisterCells() {
        view?.registerTableViewCells()
    }
    
    func didTableViewScrollToBottom() {
        view?.scrollToBottomTableView()
    }
    
    func didShowErrorMessage(error: Error) {
        print("\(error.localizedDescription)")
    }
}
