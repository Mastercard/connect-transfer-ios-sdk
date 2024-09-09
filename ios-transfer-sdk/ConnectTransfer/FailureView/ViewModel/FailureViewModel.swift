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
    
    private var partnerName: String?
    private var themeColor: UIColor
    private var returnToButtonTitleTextColor: UIColor
    private var errorModel: ErrorModel?
    
    init(partnerName: String?, themeColor: UIColor, errorModel: ErrorModel?, returnToButtonTitleTextColor: UIColor = .white) {
        self.partnerName = partnerName
        self.themeColor = themeColor
        self.errorModel = errorModel
        self.returnToButtonTitleTextColor = returnToButtonTitleTextColor
    }
    
    func getThemeColor() -> UIColor {
        return themeColor
    }
    
    func getReturnToButtonTitleTextColor() -> UIColor {
        returnToButtonTitleTextColor
    }
    
    func getPartnerName() -> String {
        self.partnerName ?? ""
    }
    
    func getErrorModelCode() -> String? {
        self.errorModel?.code
    }
    
    func getErrorModelMessage() -> String? {
        self.errorModel?.userMessage
    }
}
