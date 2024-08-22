//
//  TransferModel.swift
//  Connect
//
//  Created by Prathamesh Salawkar on 06/08/24.
//  Copyright © 2024 finicity. All rights reserved.
//

import UIKit

struct FailureModel: Codable {
    let partnerName : String?

    enum CodingKeys: String, CodingKey {

        case partnerName = "partnerName"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        partnerName = try values.decodeIfPresent(String.self, forKey: .partnerName)
    }

}

