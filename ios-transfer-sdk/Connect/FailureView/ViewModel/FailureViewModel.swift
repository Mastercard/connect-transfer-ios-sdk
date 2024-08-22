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

    func getThemeColor() -> UIColor {
        return UIColor(red: 207/255, green: 69/255, blue: 0, alpha: 1.0)
    }
    
    func getReturnToButtonTitleTextColor() -> UIColor {
        .white
    }
    
}
