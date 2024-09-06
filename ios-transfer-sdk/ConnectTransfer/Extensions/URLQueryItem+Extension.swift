//
//  URLQueryItem+Extension.swift
//  Connect
//
//  Created by Anupam Kumar on 20/08/24.
//  Copyright © 2024 finicity. All rights reserved.
//

import UIKit

extension URLQueryItem {
    
    func getQueryValue(for key: String) -> String? {
        if self.name == key, let value = self.value?.removingPercentEncoding as? String {
            return value
        }
        return nil
    }
}
