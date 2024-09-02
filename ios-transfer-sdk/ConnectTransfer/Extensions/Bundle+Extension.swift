//
//  Bundle+Extension.swift
//  Connect
//
//  Created by Anupam Kumar on 12/08/24.
//  Copyright © 2024 finicity. All rights reserved.
//

import Foundation

extension Bundle {
    private static var languageBundle: Bundle?
    
    static func setLanguage(_ language: String) {        
        let path =  Bundle.getFrameworkBundle().path(forResource: language, ofType: "lproj")
        guard let bundlePath = path else { return }
        languageBundle = Bundle(path: bundlePath)
    }
    
    static func localizedString(forKey key: String, value: String? = nil, table: String? = nil) -> String {
        return languageBundle?.localizedString(forKey: key, value: value, table: table) ?? key
    }
    
    class func getFrameworkBundle() -> Bundle {
        Bundle(for: ConnectTransferViewController.self)
    }
}
