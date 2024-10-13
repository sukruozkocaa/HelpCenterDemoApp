//
//  HelpCenterStepManager.swift
//  HelpCenterDemoApp
//
//  Created by Şükrü on 12.10.2024.
//

import Foundation
import UIKit

// MARK: - HelpCenterStepManager
final class HelpCenterStepManager {
    static let shared = HelpCenterStepManager()
    
    func createStepDetails(stepId: HelpCenterChatStepTypes) -> HelpCenterResponseModel? {
        guard let responseDetail = stepId.stepDetail else { return nil }
        return responseDetail
    }
}
