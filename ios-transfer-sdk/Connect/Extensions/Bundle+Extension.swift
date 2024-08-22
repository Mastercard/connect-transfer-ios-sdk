//
//  Bundle+Extension.swift
//  Connect
//
//  Created by Anupam Kumar on 12/08/24.
//  Copyright © 2024 finicity. All rights reserved.
//

import Foundation

extension Bundle {
    private static var bundle: Bundle?
    
    static func setLanguage(_ language: String) {
        let path = Bundle.main.path(forResource: language, ofType: "lproj")
        guard let bundlePath = path else { return }
        bundle = Bundle(path: bundlePath)
    }
    
    static func localizedString(forKey key: String, value: String? = nil, table: String? = nil) -> String {
        return bundle?.localizedString(forKey: key, value: value, table: table) ?? key
    }
}
