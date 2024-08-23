//
//  UIImage+Extension.swift
//  Connect
//
//  Created by Anupam Kumar on 05/08/24.
//  Copyright © 2024 finicity. All rights reserved.
//

import UIKit

//MARK: - UIImage Extension Methods
public extension UIImage {
    
    func renderAlwaysWithTemplateMode() -> UIImage {
        self.withRenderingMode(.alwaysTemplate)
    }
    
}
