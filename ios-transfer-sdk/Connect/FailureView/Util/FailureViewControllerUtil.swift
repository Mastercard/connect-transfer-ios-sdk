//
//  FailureViewControllerUtil.swift
//  Connect
//
//  Created by Prathamesh Salawkar on 06/08/24.
//  Copyright © 2024 finicity. All rights reserved.
//

import UIKit

class FailureViewControllerUtil: NSObject{
    
    class func getFailureTitleText() -> String {
        "Looks like there was an issue"
    }
    
    class func getFailureDescriptionText() -> String {
        "We weren’t able to connect to your data."
    }
    
    class func getTryAgainText() -> String {
        "Try again"
    }
    
    class func getReturnToButtonText() -> String {
        "Return to {Partner}"
    }
    
    
    class func getDefaultOnLightTextColor() -> UIColor {
        UIColor(red: 20/255, green: 20/255, blue: 19/255, alpha: 1.0)
    }
    
    class func getRedirectingTextColor() -> UIColor {
        UIColor(red: 63/255, green: 75/255, blue: 88/255, alpha: 1.0)
    }
}
