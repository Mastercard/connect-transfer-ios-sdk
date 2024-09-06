//
//  Config.swift
//  MastercardOpenBanking
//
//  Created by Prathamesh Salawkar on 2/26/24.
//

import Foundation

struct ConfigProduction {
    static let apiBaseUrl = "https://api.finicity.com"
    static let partnerID = ProcessInfo.processInfo.environment["PARTNER_ID_SAVED"]!
    static let partnerSecret = ProcessInfo.processInfo.environment["PARTNER_SECRET_SAVED"]!
    static let appKey = ProcessInfo.processInfo.environment["FINICITY_APP_KEY_SAVED"]!
    static let applicationID = "1babcadd-0ff1-4a53-b3a6-34e0fe0f2bed"
    static var cookie_cfduid = "d6ce34251e11470b0ab3ffbd4e0b3d8141614881913"
    static var cookie_cf_bm = ""
    static var token = ""
    static var customerID = ""
    static var consumerID = ""
    static var link = ""
}

struct MastercardOpenBankingConnectEndpoints {
    struct authenticateEndpoint {
        static let url = "https://api.finicity.com/aggregation/v2/partners/authentication"
    }
    struct customerEndpoint {
        static let url = "https://api.finicity.com/aggregation/v1/customers/testing"
    }
    struct consumerEndpoint {
        static var url = "https://api.finicity.com/decisioning/v1/customers/{{CUSTOMER_ID}}/consumer"
    }
    struct generateUrlEndpoint {
        static let url = "https://api.finicity.com/connect/v2/generate"
    }
}
