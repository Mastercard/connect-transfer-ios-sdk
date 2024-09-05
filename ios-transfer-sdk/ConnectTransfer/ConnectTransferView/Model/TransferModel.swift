//
//  TransferModel.swift
//  Connect
//
//  Created by Anupam Kumar on 29/07/24.
//  Copyright © 2024 finicity. All rights reserved.
//

import UIKit

struct TransferModel: Codable {
    let token : String?
    let transferData : TransferData?

    enum CodingKeys: String, CodingKey {

        case token = "token"
        case transferData = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        token = try values.decodeIfPresent(String.self, forKey: .token)
        transferData = try values.decodeIfPresent(TransferData.self, forKey: .transferData)
    }

}

struct TransferData: Codable {
    let experience : Experience?
    let internalPartnerId : String?
    let customerType : String?
    let metadata : Metadata?
    let product : String?
    let userToken : String?

    enum CodingKeys: String, CodingKey {

        case experience = "experience"
        case internalPartnerId = "internalPartnerId"
        case customerType = "customerType"
        case metadata = "metadata"
        case product = "product"
        case userToken = "userToken"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        experience = try values.decodeIfPresent(Experience.self, forKey: .experience)
        internalPartnerId = try values.decodeIfPresent(String.self, forKey: .internalPartnerId)
        customerType = try values.decodeIfPresent(String.self, forKey: .customerType)
        metadata = try values.decodeIfPresent(Metadata.self, forKey: .metadata)
        product = try values.decodeIfPresent(String.self, forKey: .product)
        userToken = try values.decodeIfPresent(String.self, forKey: .userToken)
    }

}

struct Experience : Codable {

    var id:String?
    
    enum CodingKeys: CodingKey {
        
    }

    init(from decoder: Decoder) throws {
        _ = try decoder.container(keyedBy: CodingKeys.self)
    }

}

struct Metadata : Codable {
    let id : String?
    let applicationName : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case applicationName = "applicationName"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        applicationName = try values.decodeIfPresent(String.self, forKey: .applicationName)
    }

    func getMetaDataDict() -> [String:String]? {
        
        guard let id = self.id else {
            return nil
        }
        
        guard let applicationName = self.applicationName else {
            return nil
        }
        
        let metaDataDict = [CodingKeys.id.rawValue: id, CodingKeys.applicationName.rawValue: applicationName]
        
        return metaDataDict
    }
}

// MARK: - Welcome
struct ErrorModel: Codable {
    let code, status, message, userMessage: String
    let tags: String

    enum CodingKeys: String, CodingKey {
        case code, status, message
        case userMessage = "user_message"
        case tags
    }
}
