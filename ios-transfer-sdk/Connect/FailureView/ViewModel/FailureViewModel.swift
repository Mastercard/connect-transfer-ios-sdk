//
//  ConnectFailureViewModel.swift
//  Connect
//
//  Created by Prathamesh Salawkar on 06/08/24.
//  Copyright © 2024 finicity. All rights reserved.
//

import UIKit
import Combine

class FailureViewModel: NSObject {
    
    private var partnerName: String
    private var themeColor: UIColor
    private var returnToButtonTitleTextColor: UIColor
    
    init(partnerName: String, themeColor: UIColor, returnToButtonTitleTextColor: UIColor = .white) {
        self.partnerName = partnerName
        self.themeColor = themeColor
        self.returnToButtonTitleTextColor = returnToButtonTitleTextColor
    }
    
    func getThemeColor() -> UIColor {
        return themeColor
    }
    
    func getReturnToButtonTitleTextColor() -> UIColor {
        returnToButtonTitleTextColor
    }
    
    func getPartnerName() -> String {
        self.partnerName
    }
    
}
