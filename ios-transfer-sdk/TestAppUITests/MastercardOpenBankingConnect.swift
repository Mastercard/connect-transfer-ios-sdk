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
                    let customerRequest = CustomerModelRequest(username: "\(Int(Date().timeIntervalSince1970))", firstName: "oeu", lastName: "aoue", applicationId: ConfigProduction.applicationID)
                    return MastercardOpenBankingConnectAPI.request(endpoint: MastercardOpenBankingConnectEndpoints.customerEndpoint.url, params: customerRequest, type: CustomerModelResult.self)
                }
                .flatMap { result -> AnyPublisher<GenerateUrlModelResult, Error> in
                    let account = Account(accountNumber: "1111111111", bankIdentifier: "222222222", type: "checking")
                    ConfigProduction.customerID = result.id
                    
                    let generateRequest =
                        GenerateUrlModelRequest(
                            partnerId: ConfigProduction.partnerID,
                            customerId: ConfigProduction.customerID,
                            accounts: [account])
                    return MastercardOpenBankingConnectAPI.request(endpoint: MastercardOpenBankingConnectEndpoints.generatePDSUrlEndpoint.url, params: generateRequest, type: GenerateUrlModelResult.self)
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
