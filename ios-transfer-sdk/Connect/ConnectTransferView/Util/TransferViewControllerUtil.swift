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
        "Allow Mastercard [Finicity, a Mastercard Company] to direct you to Atomic to securely connect to your payroll provider and manage changes to your deposit allocation." //getLocalizedString(for: "landing_page_subtitle")
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
        "By pressing Next, you agree to Mastercard’s [Finicity’s] Terms of Use and Privacy Notice"//getLocalizedString(for: "landing_page_terms_and_condtions_info_text")
    }
    
    class func getTermsAndConditionsText() -> String {
        "Terms of Use" //getLocalizedString(for: "terms_and_condtions_text")
    }
    
    class func getPrivacyNoticeText() -> String {
        "Privacy Notice"//getLocalizedString(for: "privacy_notice_text")
    }
    
    class func getNextButtonText() -> String {
        getLocalizedString(for: "next_text")
    }
    
    class func getPoweredByText() -> String {
        "Secured By"//getLocalizedString(for: "powered_by_text")
    }
    
    class func getAtomicText() -> String {
        "Atomic"
    }
    
    class func getFincityText() -> String {
        "Finicity, a Mastercard company"
    }
    
    class func getMastercardText() -> String {
        "Mastercard"
    }
    
    class func getRedirectingText() -> String {
        getLocalizedString(for: "redirecting_text")
    }
    
    class func getStepInstructionText() -> String {
        "You’ll need to"
    }
    
    class func getPermissionText() -> String {
        "Mastercard [Finicity] only uses data with your permission"
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
