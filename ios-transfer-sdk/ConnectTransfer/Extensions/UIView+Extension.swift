//
//  UIView+Extension.swift
//  Connect
//
//  Created by Anupam Kumar on 08/08/24.
//  Copyright © 2024 finicity. All rights reserved.
//

import UIKit

extension UIView {
    
    func setBorder(borderRadius: CGFloat = 1.0, borderColor: UIColor) {
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderRadius
    }
    
    func applyRoundedCorners(cornerRadius: CGFloat, corners: CACornerMask) {        
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadius
        self.layer.maskedCorners = corners //[.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
}
