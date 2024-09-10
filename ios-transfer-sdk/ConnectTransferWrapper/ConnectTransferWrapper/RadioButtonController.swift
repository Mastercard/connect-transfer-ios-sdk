//
//  RadioButtonController.swift
//  ConnectTransferWrapper
//
//  Created by Prathamesh Salawkar on 03/06/24.
//  Copyright © 2024 finicity. All rights reserved.
//

import Foundation
import UIKit

class RadioButtonController: NSObject {
    var buttonsArray: [UIButton]! {
        didSet {
            for b in buttonsArray {
                b.setImage(UIImage(named: "radio_off"), for: .normal)
                b.setImage(UIImage(named: "radio_on"), for: .selected)
            }
        }
    }
    var selectedButton: UIButton?
    var defaultButton: UIButton = UIButton() {
        didSet {
            buttonArrayUpdated(buttonSelected: self.defaultButton)
        }
    }

    func buttonArrayUpdated(buttonSelected: UIButton) {
        for b in buttonsArray {
            if b == buttonSelected {
                selectedButton = b
                b.isSelected = true
            } else {
                b.isSelected = false
            }
        }
    }
}
