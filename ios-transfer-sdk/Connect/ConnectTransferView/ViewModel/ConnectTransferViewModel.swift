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
    private let pdsTermsAndConditionAPIPath = "server/terms-and-policies"
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
        
        self.transferModelURString = urlString
        
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
            transferModelURL = "http://\(host):\(port)/\(pdsAPIPath)?\(queryParams)"
            
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
    
    
    func apiForTermsAndConditionConsent(completionHandler: @escaping (Bool, String?) -> Void) {
        
        guard let termsAndConditionURL = self.getURLTermsAndConditionConsentAPI(currentURLString: self.transferModelURString!) else {
            completionHandler(false, nil)
            return
        }
        
        
        let parameters : [String:Any] = ["context":"partner","language":"en","termsAndConditionsVersion":"20231121","privacyPolicyVersion":"20230925"]
        
        guard let httpBody = try? JSONSerialization.data(
            withJSONObject: parameters,
            options: []
        )
        else {
            return
        }
        
        var urlRequest = URLRequest(url: termsAndConditionURL)
        urlRequest.httpMethod = "PUT"
        
        urlRequest.httpBody = httpBody// pass dictionary to data object and set it as request
        
        let headers = ["authorization": "Bearer " + (transferModel?.token)!]
        
        
        
        for (key, value) in headers {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                
                DispatchQueue.main.async {
                    completionHandler(false, error?.localizedDescription)
                }
                return
            }
            
            guard let data = data else { return }
            
            if(response != nil){
                let httpUrlResponse:HTTPURLResponse = response as! HTTPURLResponse
                // handle data
                if(httpUrlResponse.statusCode == 200){
                    DispatchQueue.main.async {
                        completionHandler(true,"Successfully completed terms and conditions")
                    }
                }else{
                    DispatchQueue.main.async {
                        completionHandler(false, httpUrlResponse.description)
                    }
                }
            }else{
                DispatchQueue.main.async {
                    completionHandler(false, "No Response from server")
                }
            }
        }.resume()
        
        
    }
    
    
    func getURLTermsAndConditionConsentAPI(currentURLString: String) -> URL? {
        
        guard let currentURL = URL(string: currentURLString) else {
            return nil
        }
        
        guard let queryParams = currentURL.query else {
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
            transferModelURL = "http://\(host):\(port)/\(pdsTermsAndConditionAPIPath)"
            
        }else {
            transferModelURL = "https://\(host)/\(pdsTermsAndConditionAPIPath)"
        }
        return URL(string: transferModelURL)
    }
}
