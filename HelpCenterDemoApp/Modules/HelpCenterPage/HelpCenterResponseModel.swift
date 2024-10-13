//
//  HelpCenterResponseModel.swift
//  HelpCenterDemoApp
//
//  Created by Şükrü on 12.10.2024.
//

import Foundation

// MARK: - StepTypes
enum StepTypes: Codable {
    case button
    case text
    case image
    case userBubble
}

// MARK: - HelpCenterResponseModel
struct HelpCenterResponseModel: Codable {
    let step: HelpCenterChatStepTypes?
    let type: StepTypes?
    let content: ContentType?
    let action: HelpCenterChatStepTypes?
}

// MARK: - HelpCenterContentModel
struct HelpCenterContentModel: Codable {
    let text: String?
    let buttons: [HelpCenterContentButtonModel]?
}

// MARK: - HelpCenterContentButtonModel
struct HelpCenterContentButtonModel: Codable {
    let label: String?
    let action: HelpCenterChatStepTypes?
}

// MARK: - Enum ContentType
enum ContentType: Codable {
    case text(String)
    case buttons(HelpCenterContentModel)
    
    /// Custom decoding to handle different content types
    init(from decoder: Decoder) throws {
        
        /// We use a singleValueContainer to extract the raw value from the decoder.
        let container = try decoder.singleValueContainer()
        
        /// First, we attempt to decode the content as a String.
        if let textContent = try? container.decode(String.self) {
            /// If successful, we assign the decoded value to the .text case.
            self = .text(textContent)
        } else if let buttonContent = try? container.decode(HelpCenterContentModel.self) {
            /// // If successful, we assign the decoded value to the .buttons case.
            self = .buttons(buttonContent)
        } else {
            /// If neither decoding succeeds, we throw an error indicating a type mismatch.
            throw DecodingError.typeMismatch(
                ContentType.self,
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Unknown ContentType"
                )
            )
        }
    }
    
    /// Custom encoding to handle different content types
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .text(let textContent):
            try container.encode(textContent)
        case .buttons(let buttonContent):
            try container.encode(buttonContent)
        }
    }
}
