//
//  OpenLinkURL.swift
//  Connect
//
//  Created by Prathamesh Salawkar on 12/1/23.
//  Copyright © 2023 finicity. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

public class OpenLinkURL {
    typealias completionHandler = (_ success:Bool) -> Void
    static func inAnyNativeWay(url: URL, dontPreferEmbeddedBrowser: Bool = false,completion: @escaping completionHandler) { // OPEN AS UNIVERSAL LINK IF EXISTS else : EMBEDDED or EXTERNAL
        if #available(iOS 10.0, *) {
            // Try to open with owner universal link app
            UIApplication.shared.open(url, options: [UIApplication.OpenExternalURLOptionsKey.universalLinksOnly : true]) { (success) in
                if !success {
                    completion(false)
                }
            }
        } else {
            completion(false)
        }
    }
}
