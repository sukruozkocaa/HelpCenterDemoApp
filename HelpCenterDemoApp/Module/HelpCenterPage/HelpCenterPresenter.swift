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
    
    // View -> Presenter
    func viewDidLoad()
    func loadUI()
    func registerTableViewCells()
    
    func connectWebSocket()
    func disconnectWebSocket()
    func sendSocketMessage(stepId: HelpCenterStepTypes)
    func calculateCellHeight(response: HelpCenterResponseModel) -> CGFloat
    func createUserSendBubble(bubbleMessage: String)
    func heightForHeaderInSection() -> CGFloat
    func dequeueReusableCell(_ response: HelpCenterResponseModel, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
}

// MARK: - HelpCenterPresenter
final class HelpCenterPresenter: HelpCenterPresenterProtocol {
    
    // MARK: - Base
    var view: HelpCenterViewProtocol?
    var interactor: HelpCenterInteractorProtocol?
    var router: HelpCenterRouterProtocol?

    func viewDidLoad() {
        loadUI()
        registerTableViewCells()
        connectWebSocket()
        interactor?.getHelpCenterStepDetails(stepId: .step1)
    }
    
    func sendSocketMessage(stepId: HelpCenterStepTypes) {
        self.interactor?.getHelpCenterStepDetails(stepId: stepId)
    }
    
    func connectWebSocket() {
        interactor?.connectWebSocket(socketURL: "wss://echo.websocket.org")
    }
    
    func disconnectWebSocket() {
        interactor?.disconnectWebSocket()
    }
    
    func calculateCellHeight(response: HelpCenterResponseModel) -> CGFloat {
        guard let height = interactor?.calculateCellHeight(response) else { return .zero }
        return height
    }
    
    func registerTableViewCells() {
        view?.registerTableViewCells()
    }
    
    func loadUI() {
        view?.loadUI()
    }
    
    func createUserSendBubble(bubbleMessage: String) {
        interactor?.createUserSendBubbleView(bubbleMessage: bubbleMessage)
    }
    
    func heightForHeaderInSection() -> CGFloat {
        return 10.0
    }
    
    func dequeueReusableCell(_ response: HelpCenterResponseModel, tableView: UITableView,  indexPath: IndexPath) -> UITableViewCell {
        guard let cell = interactor?.dequeueReusableCell(response, tableView: tableView, indexPath: indexPath) else { return UITableViewCell() }
        return cell
    }
    
}

// MARK: - HelpCenterInteractorResponseProtocol
extension HelpCenterPresenter: HelpCenterInteractorResponseProtocol {
    func didGetStepDetails(stepDetails: HelpCenterResponseModel) {
        view?.displayMessage(stepDetails)
    }
    
    func didSocketConnected() {
        print("Socket Connected")
    }
    
    func didSocketDisconnected() {
        print("Socket Disconnected")
    }
}
