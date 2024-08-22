//
//  ExitPopUpViewControllerUtil.swift
//  Connect
//
//  Created by Anupam Kumar on 08/08/24.
//  Copyright © 2024 finicity. All rights reserved.
//

import UIKit

class ExitPopUpViewControllerUtil: NSObject {

    class func getLocalizedString(for key: String) -> String {
        return Bundle.localizedString(forKey: key)
    }
    
    class func getExitPopUpTitleText() -> String {
        getLocalizedString(for: "exit_pop_up_title")
    }

    class func getExitPopUpDescriptionText() -> String {
        getLocalizedString(for: "exit_pop_up_subtitle")
    }
    
    class func getExitButtonText() -> String {
        getLocalizedString(for: "yes_exit")
    }
    
    class func getStayButtonText() -> String {
        getLocalizedString(for: "no_stay")
    }
    
    class func getExitPopUpTitleTextColor() -> UIColor {
        UIColor(red: 33/255, green: 43/255, blue: 54/255, alpha: 1.0)
    }
    
    class func getExitPopUpDescriptionTextColor() -> UIColor {
        UIColor(red: 97/255, green: 111/255, blue: 125/255, alpha: 1.0)
    }
    
    class func getExitPopUpBackgroundColor() -> UIColor {
        UIColor(red: 249/255, green: 250/255, blue: 252/255, alpha: 1.0)
    }
}
