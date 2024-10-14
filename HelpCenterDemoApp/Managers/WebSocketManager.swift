//
//  WebSocketManager.swift
//  HelpCenterDemoApp
//
//  Created by Şükrü on 12.10.2024.
//

import Foundation

// MARK: - WebSocketInteractorDelegate
protocol WebSocketInteractorDelegate: AnyObject {
    func didReceiveMessage(_ message: HelpCenterResponseModel)
    func didFailWithError(_ error: Error)
}

// MARK: - WebSocketManager (Singleton)
final class WebSocketManager {
    // MARK: - Singleton Instance
    static let shared = WebSocketManager()

    // MARK: - Delegate
    weak var delegate: WebSocketInteractorDelegate?

    // MARK: - WebSocket Task and URLSession
    private var webSocketTask: URLSessionWebSocketTask?
    private var urlSession: URLSession?

    private init() {}

    // MARK: - Connect WebSocket
    func connectWebSocket(socketURL: String) {
        guard let url = URL(string: socketURL) else { return }
        urlSession = URLSession(configuration: .default)
        webSocketTask = urlSession?.webSocketTask(with: url)
        webSocketTask?.resume()

        listenForMessages()
    }

    // MARK: - Disconnect WebSocket
    func disconnectWebSocket() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        webSocketTask = nil
        urlSession = nil
    }

    // MARK: - Send Message
    func sendMessage(_ message: HelpCenterResponseModel) {
        do {
            let jsonData = try JSONEncoder().encode(message)
            
            guard let jsonString = String(data: jsonData, encoding: .utf8) else { return }
            let webSocketMessage = URLSessionWebSocketTask.Message.string(jsonString)
            
            webSocketTask?.send(webSocketMessage) { [weak self] error in
                guard let self = self else { return }
                if let error = error {
                    self.delegate?.didFailWithError(error)
                }
            }
        } catch {
            delegate?.didFailWithError(error)
        }
    }
}

// MARK: - Utils
private extension WebSocketManager {
    func listenForMessages() {
        webSocketTask?.receive { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let message):
                switch message {
                case .string(let jsonString):
                    self.handleReceivedMessage(jsonString)
                default:
                    print("Unsupported message format")
                }
            case .failure(let error):
                self.delegate?.didFailWithError(error)
            }

            self.listenForMessages()
        }
    }

    func handleReceivedMessage(_ jsonString: String) {
        guard let jsonData = jsonString.data(using: .utf8) else { return }
        do {
            let responseModel = try JSONDecoder().decode(HelpCenterResponseModel.self, from: jsonData)
            delegate?.didReceiveMessage(responseModel)
        } catch {
            delegate?.didFailWithError(error)
        }
    }
}
