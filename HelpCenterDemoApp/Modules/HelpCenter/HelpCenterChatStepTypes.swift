//
//  HelpCenterChatStepTypes.swift
//  HelpCenterDemoApp
//
//  Created by Şükrü on 13.10.2024.
//

import Foundation

// MARK: - HelpCenterStepTypes
enum HelpCenterChatStepTypes {
    case step1
    case step2
    case step3
    case step4
    case step5
    case step6
    case step7
    case await_user_choice
    case show_guide
    case end_conversation
}

// MARK: - Step Detail
extension HelpCenterChatStepTypes: Codable {
    var stepDetail: HelpCenterResponseModel? {
        switch self {
        case .step1:
            let buttons: [HelpCenterContentButtonModel] = [
                HelpCenterContentButtonModel.init(label: "İade işlemi", action: .step2),
                HelpCenterContentButtonModel.init(label: "Sipariş durumu", action: .step3),
                HelpCenterContentButtonModel.init(label: "Ürün rehberi", action: .step4),
                HelpCenterContentButtonModel.init(label: "Sohbeti bitir", action: .end_conversation),
            ]
            
            let contentModel = HelpCenterContentModel(
                text: "Merhaba, canlı destek hattına hoş geldiniz! Hangi konuda yardım almak istersiniz?",
                buttons: buttons
            )
            let content = ContentType.buttons(contentModel)
            let stepDetailResponse: HelpCenterResponseModel = .init(
                step: self,
                type: .button,
                content: content,
                action: .await_user_choice, isSelected: false
            )
            
            return stepDetailResponse
        case .step2:
            let buttons: [HelpCenterContentButtonModel] = [
                HelpCenterContentButtonModel.init(label: "Evet, kargoya verdim", action: .step5),
                HelpCenterContentButtonModel.init(label: "Hayır, henüz vermedim", action: .step6),
                HelpCenterContentButtonModel.init(label: "Sohbeti bitir", action: .end_conversation),
            ]
            
            let contentModel = HelpCenterContentModel(
                text: "İade işlemleri için ürününüzü kargoya verdiniz mi?",
                buttons: buttons
            )
            let content = ContentType.buttons(contentModel)
            let stepDetailResponse: HelpCenterResponseModel = .init(
                step: self,
                type: .button,
                content: content,
                action: .await_user_choice, isSelected: false
            )
            
            return stepDetailResponse

        case .step3:
            let content = ContentType.text("Siparişiniz şu anda kargoda. Takip numaranız: TR123456789")
            let stepDetailResponse: HelpCenterResponseModel = .init(
                step: self,
                type: .text,
                content: content,
                action: .end_conversation, isSelected: false
            )
            return stepDetailResponse
        case .step4:
            
            // TODO: Add Image URL
            let content = ContentType.text(
                "https://media.licdn.com/dms/image/v2/D4D22AQE091hLQw1pUQ/feedshare-shrink_1280/feedshare-shrink_1280/0/1703068677936?e=1731542400&v=beta&t=gRS0cWOIPOPakhFI1u7hqSpZLAPG57kXZRMu5yrK5Og"
            )
            let stepDetailResponse: HelpCenterResponseModel = .init(
                step: self,
                type: .image,
                content: content,
                action: .end_conversation, isSelected: false
            )
            
            return stepDetailResponse
        case .step5:
            let content = ContentType.text("Teşekkür ederiz! İade işleminiz kargoya ulaştığında işleme alınacaktır.")
            let stepDetailResponse: HelpCenterResponseModel = .init(
                step: self,
                type: .text,
                content: content,
                action: .end_conversation, isSelected: false
            )
            
            return stepDetailResponse
        case .step6:
            let content = ContentType.text("İade işlemi için ürünü kargoya verdikten sonra işlemler başlatılacaktır. Yardıma ihtiyacınız olursa bizimle iletişime geçebilirsiniz.")
            let stepDetailResponse: HelpCenterResponseModel = .init(
                step: self,
                type: .text,
                content: content,
                action: .end_conversation, isSelected: false
            )
            
            return stepDetailResponse
        case .step7:
            let buttons: [HelpCenterContentButtonModel] = [
                HelpCenterContentButtonModel.init(label: "Yeni bir işlem başlat", action: .step1),
                HelpCenterContentButtonModel.init(label: "Sohbeti bitir", action: .end_conversation),
            ]
            
            let contentModel = HelpCenterContentModel(
                text: "Başka nasıl yardımcı olabilirim?",
                buttons: buttons
            )
            let content = ContentType.buttons(contentModel)
            let stepDetailResponse: HelpCenterResponseModel = .init(
                step: self,
                type: .button,
                content: content,
                action: .await_user_choice, isSelected: false
            )
            
            return stepDetailResponse
        case .await_user_choice: break
        case .show_guide: break
        case .end_conversation: break
        }
        
        return nil
    }
}
