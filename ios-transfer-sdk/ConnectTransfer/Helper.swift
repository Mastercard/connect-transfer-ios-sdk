//
//  Helper.swift
//  Connect
//
//  Created by Anupam Kumar on 26/07/24.
//  Copyright © 2024 finicity. All rights reserved.
//

import UIKit

class Helper: NSObject {

    class func isCurrentDeviceiPhone() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
    class func returnFinalSizeForIpad() -> CGSize {
        return CGSize(width: 430, height: 839) // Height refers to safe area height in case of iphone 15 pro max
    }
    
    class func getTermsAndConditionsURLString() -> String {
        return "https://connect2.finicity.com/assets/html/connect-eula.html"
    }
    
    class func getPrivacyPolicyURLString() -> String {
        return "https://finicity.com/privacy"
    }
}

