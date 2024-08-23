//
//  ConnectTransferViewModel.swift
//  Connect
//
//  Created by Anupam Kumar on 31/07/24.
//  Copyright © 2024 finicity. All rights reserved.
//

import UIKit
import Combine

class ConnectTransferViewModel: NSObject {

    private var transferModel: TransferModel? = nil
    private let pdsAPIPath = "server/authenticate/v2/transfer/deposit-switch"
    private let connectTransferCompleteAPIPath = "server/auto/v2/complete"
    private var pdsAPIToken = Set<AnyCancellable>()
    private var host:String? = nil
    private var transferModelURString:String? = nil
    
    func getThemeColor() -> UIColor {
        return UIColor(red: 207/255, green: 69/255, blue: 0, alpha: 1.0)
    }
    
    func getPartenrName() -> String {
        return transferModel?.transferData?.metadata?.applicationName ?? ""
    }
    
    func getNextButtonTitleTextColor() -> UIColor {
        .white
    }
    
    func apiHitToGetTransferModel(urlString: String, completionHandler: @escaping (Bool, String?) -> Void) {
        
        guard let transferModelURL = self.getURLForTransferModelAPI(currentURLString: urlString) else {
            completionHandler(false, nil)
            return
        }
        
        var urlRequest = URLRequest(url: transferModelURL)
        urlRequest.httpMethod = "POST"
        
        URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap() { result in
                guard let httpResponse = result.response as? HTTPURLResponse, httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else {
                    throw URLError(.badServerResponse)
                }
                return result.data
            }
            .decode(type: TransferModel.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
            .sink(receiveCompletion: { (completion) in
                
                switch completion {
                case .failure(let error):
                    print("error: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        completionHandler(false, error.localizedDescription)
                    }
                    
                case .finished:
                    break
                }
                
            }) { result in
                
                self.transferModel = result
                DispatchQueue.main.async {
                    completionHandler(true, nil)
                }
            }
            .store(in: &pdsAPIToken)
        
    }
    
    func getURLForTransferModelAPI(currentURLString: String) -> URL? {
        
        guard let currentURL = URL(string: currentURLString) else {
            return nil
        }
        
        guard let queryParams = currentURL.query else {
            return nil
        }
        
        guard let host = currentURL.host else {
            return nil
        }
        
        var transferModelURL = ""
        
        if let port = currentURL.port {
            transferModelURL = "https://\(host):\(port)/\(pdsAPIPath)?\(queryParams)"
            
        }else {
            transferModelURL = "https://\(host)/\(pdsAPIPath)?\(queryParams)"
        }
        
        setUpAppLanguage(currentURLString: currentURLString)
        
        return URL(string: transferModelURL)
    }
    
    func setUpAppLanguage(currentURLString: String) {
        if let urlComponent = URLComponents(string: currentURLString) {
            
            let queryItems = urlComponent.queryItems
            
            if let languageQuery = queryItems?.first(where: { $0.name == "language" }), let languageValue = languageQuery.value, languageValue == "es"{
                Bundle.setLanguage("es")
                UserDefaults.standard.setValue(["es"], forKey: "AppleLanguages")
                
            }else {
                Bundle.setLanguage("en")
                UserDefaults.standard.setValue(["en"], forKey: "AppleLanguages")
            }
            
            UserDefaults.standard.synchronize()
        }
    
    }
    
    func apiForConnectTranserComplete(completionHandler: @escaping (Bool, String?) -> Void) {
        
        guard let connectTranserCompleteURL = self.getURLForConnectTranserComplete(currentURLString: self.transferModelURString!) else {
            completionHandler(false, nil)
            return
        }
        
        
        let parameters : [String:Any] = ["reportData":[]]
        
        
        guard let httpBody = try? JSONSerialization.data(
            withJSONObject: parameters,
            options: []
        )
        else {
            return
        }
        
        var urlRequest = URLRequest(url: connectTranserCompleteURL)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = httpBody// pass dictionary to data object and set it as request
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        let headers = ["authorization": "Bearer " + (transferModel?.token)!]
        for (key, value) in headers {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                
                DispatchQueue.main.async {
                    completionHandler(false, error?.localizedDescription)
                }
                return
            }
            guard let data = data, let response = response  else { return }
            // handle data
            DispatchQueue.main.async {
                completionHandler(true, nil)
            }
        }.resume()
    }
    
    
    func getURLForConnectTranserComplete(currentURLString: String) -> URL? {
        
        guard let currentURL = URL(string: currentURLString) else {
            return nil
        }
        
        guard let host = currentURL.host else {
            return nil
        }
        
        if(self.host != nil){
            self.host = host
        }
        
        var transferModelURL = ""
        
        if let port = currentURL.port {
            transferModelURL = "http://\(host):\(port)/\(connectTransferCompleteAPIPath)"
            
        }else {
            transferModelURL = "https://\(host)/\(connectTransferCompleteAPIPath)"
        }
        
        return URL(string: transferModelURL)
    }
}
