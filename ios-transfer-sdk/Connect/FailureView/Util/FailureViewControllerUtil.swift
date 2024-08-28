//
//  FailureViewControllerUtil.swift
//  Connect
//
//  Created by Prathamesh Salawkar on 06/08/24.
//  Copyright © 2024 finicity. All rights reserved.
//

import UIKit

class FailureViewControllerUtil: NSObject{
    
    class func getLocalizedString(for key: String) -> String {
        return Bundle.localizedString(forKey: key)
    }
    
    class func getFailureTitleText() -> String {
        getLocalizedString(for: "error_title")
    }
    
    class func getFailureDescriptionText() -> String {
        getLocalizedString(for: "error_subtitle")
    }
    
    class func getTryAgainText() -> String {
        getLocalizedString(for: "try_again")
    }
    
    class func getReturnToButtonText() -> String {
        getLocalizedString(for: "return_to_partner")
    }
    
    class func getFailureTitleTextColor() -> UIColor {
        UIColor(red: 63/255, green: 75/255, blue: 88/255, alpha: 1.0)
    }
}
