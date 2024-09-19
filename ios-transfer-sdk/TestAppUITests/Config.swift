//
//  Config.swift
//  MastercardOpenBanking
//
//  Created by Prathamesh Salawkar on 2/26/24.
//

import Foundation

struct ConfigProduction {
    static let apiBaseUrl = "https://api.finicitystg.com"
    static let partnerID = ProcessInfo.processInfo.environment["PARTNER_ID_SAVED"]!
    static let partnerSecret = ProcessInfo.processInfo.environment["PARTNER_SECRET_SAVED"]!
    static let appKey = ProcessInfo.processInfo.environment["FINICITY_APP_KEY_SAVED"]!
    static let applicationID =  ProcessInfo.processInfo.environment["APPLICATION_ID_SAVED"]!
    static var cookie_cf_bm = ""
    static var token = ""
    static var customerID = ""
    static var consumerID = ""
    static var link = ""
    static let connectBaseURL = "https://connect.finicitystg.com"
}

struct MastercardOpenBankingConnectEndpoints {
    struct authenticateEndpoint {
        static let url = "\(ConfigProduction.apiBaseUrl)/aggregation/v2/partners/authentication"
    }
    struct customerEndpoint {
        static let url = "\(ConfigProduction.apiBaseUrl)/aggregation/v2/customers/testing"
    }
    struct generatePDSUrlEndpoint {
        static let url = "\(ConfigProduction.connectBaseURL)/server/connect/generate/transfer/deposit-switch"
    }
}
