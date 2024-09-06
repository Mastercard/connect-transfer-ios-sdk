//
//  UIImage+Extension.swift
//  Connect
//
//  Created by Anupam Kumar on 05/08/24.
//  Copyright © 2024 finicity. All rights reserved.
//

import UIKit

//MARK: - UIImage Extension Methods
extension UIImage {
    
    convenience init?(named: String) {
        self.init(named: named, in: Bundle.getFrameworkBundle(), with: nil)
    }
    
    func renderAlwaysWithTemplateMode() -> UIImage {
        self.withRenderingMode(.alwaysTemplate)
    }
    
}
