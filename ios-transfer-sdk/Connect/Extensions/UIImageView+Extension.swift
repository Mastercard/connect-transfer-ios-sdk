//
//  UIImageView+Extension.swift
//  Connect
//
//  Created by Anupam Kumar on 05/08/24.
//  Copyright © 2024 finicity. All rights reserved.
//

import UIKit

//MARK: - UIImageView Extension Methods
public extension UIImageView {
    
    func setLayerRotationToInfinite() {
        
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0
        rotation.toValue = 2 * Double.pi
        rotation.duration = 0.7
        rotation.repeatCount = .infinity
        
        self.layer.removeAllAnimations()
        self.layer.add(rotation, forKey: "Spin")
        
    }
    
    func removeAllAnimations() {
        self.layer.removeAllAnimations()
    }
}

