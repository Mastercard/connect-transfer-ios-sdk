//
//  MastercardOpenBankingConnect.swift
//  MastercardOpenBanking
//
//  Created by Prathamesh Salawkar on 2/26/24.
//

import Foundation
import Combine

public enum MastercardOpenBankingConnect {
    
    static private var token: AnyCancellable? = nil
    
//    static func generateUrlLink() -> String? {
//        var urlLink: String? = nil
//        let sem = DispatchSemaphore(value: 0)
//        generateUrlLinkAsync { success, link in
//            urlLink = link
//            sem.signal()
//        }
//        sem.wait()
//        return urlLink
//    }
    
    static public func generateUrlLink(completionHandler: @escaping (Bool,String?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let authRequest = AuthenticateModelRequest(partnerId: ConfigProduction.partnerID, partnerSecret: ConfigProduction.partnerSecret)
            token = MastercardOpenBankingConnectAPI.request(endpoint: MastercardOpenBankingConnectEndpoints.authenticateEndpoint.url, params: authRequest, type: AuthenticationModelResult.self, appToken: false)
                .flatMap { result -> AnyPublisher<CustomerModelResult, Error> in
                    ConfigProduction.token = result.token
                    let customerRequest = CustomerModelRequest(username: "\(Int(Date().timeIntervalSince1970))", firstName: "oeu", lastName: "aoue")
                    return MastercardOpenBankingConnectAPI.request(endpoint: MastercardOpenBankingConnectEndpoints.customerEndpoint.url, params: customerRequest, type: CustomerModelResult.self)
                }
                .flatMap { result -> AnyPublisher<ConsumerModelResult, Error> in
                    ConfigProduction.customerID = result.id
                    let data = consumerTemplateString.data(using: .utf8)!
                    let consumerRequest = try! JSONDecoder().decode(ConsumerModelRequest.self, from: data)
                    let url = "https://api.finicity.com/decisioning/v1/customers/\(ConfigProduction.customerID)/consumer"
                    return MastercardOpenBankingConnectAPI.request(endpoint: url, params: consumerRequest, type: ConsumerModelResult.self)
                }
                .flatMap { result -> AnyPublisher<GenerateUrlModelResult, Error> in
                    ConfigProduction.consumerID = result.id
                    let generateRequest =
                        GenerateUrlModelRequest(
                            partnerId: ConfigProduction.partnerID,
                            customerId: ConfigProduction.customerID,
                            consumerId: ConfigProduction.consumerID)
                    return MastercardOpenBankingConnectAPI.request(endpoint: MastercardOpenBankingConnectEndpoints.generateUrlEndpoint.url, params: generateRequest, type: GenerateUrlModelResult.self)
                }
                .sink(receiveCompletion: { (completion) in
                    // Called once, when the publisher completes.
                    switch completion {
                    case .failure(let error):
                        print("error: \(error.localizedDescription)")
                        DispatchQueue.main.async {
                            completionHandler(false,nil)
                        }
                        token = nil
                    case .finished:
                        token = nil
                    }
                }) { result in
                    // Can be called multiple times, each time that a
                    // new value was emitted by the publisher.
                    // print(result.link)
                    DispatchQueue.main.async {
                        completionHandler(true,result.link)
                        token = nil
                    }
                }
        }

    }

}
