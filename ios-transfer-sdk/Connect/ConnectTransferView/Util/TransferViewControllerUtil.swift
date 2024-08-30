//
//  TransferViewControllerUtil.swift
//  Connect
//
//  Created by Anupam Kumar on 29/07/24.
//  Copyright © 2024 finicity. All rights reserved.
//

import UIKit

class TransferViewControllerUtil: NSObject{
    
    class func getLocalizedString(for key: String) -> String {
        return Bundle.localizedString(forKey: key)
    }
    
    class func getTransferTitleText() -> String {
        getLocalizedString(for: "landing_page_title")
    }
    
    class func getTransferDescriptionText() -> String {
        getLocalizedString(for: "landing_page_subtitle")
    }
    
    class func getTransferFirstStepText() -> String {
        getLocalizedString(for: "landing_page_instruction_first_step_text")
    }
    
    class func getTransferSecondStepText() -> String {
        getLocalizedString(for: "landing_page_instruction_second_step_text")
    }
    
    class func getTransferThirdStepText() -> String {
        getLocalizedString(for: "landing_page_instruction_third_step_text")
    }
    
    class func getTransferFourthStepText() -> String {
        getLocalizedString(for: "landing_page_instruction_fourth_step_text")
    }
    
    class func getTransferTermsAndConditionsAndPrivacyText() -> String {
        getLocalizedString(for: "landing_page_terms_and_condtions_info_text")
    }
    
    class func getTermsAndConditionsText() -> String {
        getLocalizedString(for: "terms_and_condtions_text")
    }
    
    class func getPrivacyNoticeText() -> String {
        getLocalizedString(for: "privacy_notice_text")
    }
    
    class func getNextButtonText() -> String {
        getLocalizedString(for: "next_text")
    }
    
    class func getPoweredByText() -> String {
        getLocalizedString(for: "secured_by_text")
    }
    
    class func getAtomicText() -> String {
        "Atomic"
    }
    
    class func getFincityText() -> String {
        "Finicity, a Mastercard Company"
    }
    
    class func getRedirectingText() -> String {
        getLocalizedString(for: "redirecting_text")
    }
    
    class func getStepInstructionText() -> String {
        getLocalizedString(for: "landing_page_step_instruction_text")
    }
    
    class func getPermissionText() -> String {
        getLocalizedString(for: "finicity_permission_text")
    }
    
    class func getDefaultOnLightTextColor() -> UIColor {
        UIColor(red: 20/255, green: 20/255, blue: 19/255, alpha: 1.0)
    }
    
    class func getRedirectingTextColor() -> UIColor {
        UIColor(red: 63/255, green: 75/255, blue: 88/255, alpha: 1.0)
    }
    
    class func getAllStepBackgroundColor() -> UIColor {
        UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1.0)
    }
    
    class func getAllStepBorderColor() -> UIColor {
        UIColor(red: 223/255, green: 223/255, blue: 223/255, alpha: 1.0)
    }
    
    class func getPermissionTextColor() -> UIColor {
        UIColor(red: 150/255, green: 145/255, blue: 139/255, alpha: 1.0)
    }
}
