//
//  ConnectTransferRedirectViewModel.swift
//  Connect
//
//  Created by Anupam Kumar on 09/08/24.
//  Copyright © 2024 finicity. All rights reserved.
//

import UIKit

class ConnectTransferRedirectViewModel: NSObject {

    private var partnerName: String
    private var themeColor: UIColor
    private var exitButtonTextColor: UIColor
    
    init(partnerName: String, themeColor: UIColor, exitButtonTextColor: UIColor = .white) {
        self.partnerName = partnerName
        self.themeColor = themeColor
        self.exitButtonTextColor = exitButtonTextColor
    }
    
    func getThemeColor() -> UIColor {
        self.themeColor
    }
    
    func getPartnerName() -> String {
        self.partnerName
    }
}
