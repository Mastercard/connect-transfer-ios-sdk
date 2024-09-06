//
//  MastercardOpenBankingConnectAPI.swift
//  MastercardOpenBankingConnect
//
//  Created by Prathamesh Salawkar on 2/26/24.
//

import Foundation
import Combine

enum MastercardOpenBankingConnectAPI {
    
    static private let decoder = JSONDecoder()
    static private let encoder = JSONEncoder()
    static private let session = URLSession(configuration: URLSessionConfiguration.ephemeral)
    
    static func request<R: Encodable,T: Decodable>(endpoint: String, params: R, type: T.Type, appToken: Bool = true) -> AnyPublisher<T, Error> {
        let url = URL(string: endpoint)!
        var request = URLRequest(url: url)
        
        encoder.outputFormatting = .prettyPrinted
        let jsondata = try! encoder.encode(params)
        request.httpBody = jsondata

        addCommonHeaders(to: &request, appToken: appToken)
        return run(request)
    }
    
    static private func run<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, Error> {
        return session
            .dataTaskPublisher(for: request)
            .tryMap() { result in
                guard let httpResponse = result.response as? HTTPURLResponse, httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else {
                    throw URLError(.badServerResponse)
                }
                return result.data
            }
            .decode(type: T.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    static private func addCommonHeaders(to request: inout URLRequest, appToken: Bool) {
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("\(ConfigProduction.appKey)", forHTTPHeaderField: "Finicity-App-Key")
        if appToken { request.addValue("\(ConfigProduction.token)", forHTTPHeaderField: "Finicity-App-Token") }
    }
}
