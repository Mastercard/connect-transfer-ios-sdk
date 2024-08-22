//
//  UIApplication+Extension.swift
//  Connect
//
//  Created by Anupam Kumar on 05/08/24.
//  Copyright © 2024 finicity. All rights reserved.
//

import UIKit

//MARK: - UIApplication Extension Methods
public extension UIApplication {
    
    func currentUIWindow() -> UIWindow? {
        
        if #available(iOS 15, *) {
            
            let connectedScenes = UIApplication.shared.connectedScenes
                .filter { $0.activationState == .foregroundActive }
                .compactMap { $0 as? UIWindowScene }
            
            let window = connectedScenes.first?
                .windows
                .first { $0.isKeyWindow }
            
            return window
            
        }else {
            return UIApplication.shared.windows.first
        }
        
    }
    
    func getParentViewSizeForiPhone() -> CGSize {
        
        guard let currentWindow = UIApplication.shared.currentUIWindow() else {
            return CGSize.zero
        }
        
        let safeArea = currentWindow.safeAreaInsets
        let topInset = safeArea.top
        let bottomInset = safeArea.bottom
        
        return CGSize(width: currentWindow.frame.width, height: currentWindow.frame.height - (topInset + bottomInset))
        
    }
}
