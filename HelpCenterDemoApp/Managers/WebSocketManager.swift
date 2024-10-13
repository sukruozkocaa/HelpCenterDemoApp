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
    // Singleton Instance
    static let shared = WebSocketManager()

    // Delegate
    weak var delegate: WebSocketInteractorDelegate?

    // WebSocket Task and URLSession
    private var webSocketTask: URLSessionWebSocketTask?
    private var urlSession: URLSession? // Keep session alive

    private init() {} // Prevent external initialization

    // MARK: - Connect WebSocket
    func connectWebSocket(socketURL: String) {
        guard let url = URL(string: socketURL) else { return }
        urlSession = URLSession(configuration: .default) // Keep URLSession alive
        webSocketTask = urlSession?.webSocketTask(with: url)
        webSocketTask?.resume()

        // Start listening for messages
        listenForMessages()
    }

    // MARK: - Disconnect WebSocket
    func disconnectWebSocket() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        webSocketTask = nil
        urlSession = nil // Clean up session
    }

    // MARK: - Send Message
    func sendMessage(_ message: HelpCenterResponseModel) {
        do {
            let jsonData = try JSONEncoder().encode(message)
            let jsonString = String(data: jsonData, encoding: .utf8)!
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

            // Listen for the next message
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
