//
//  ConnectTransferRedirectViewModel.swift
//  Connect
//
//  Created by Anupam Kumar on 09/08/24.
//  Copyright © 2024 finicity. All rights reserved.
//

import UIKit

class ConnectTransferRedirectViewModel: NSObject {

    private var partnerName: String
    private var themeColor: UIColor
    private var pdsBaseURLString: String?
    private var transferModelToken: String?
    private var exitButtonTextColor: UIColor
    private let connectTransferCompleteAPIPath = "server/auto/v2/complete"
    
    init(partnerName: String, themeColor: UIColor, pdsBaseURLString: String?, transferModelToken: String?, exitButtonTextColor: UIColor = .white) {
        self.partnerName = partnerName
        self.themeColor = themeColor
        self.pdsBaseURLString = pdsBaseURLString
        self.transferModelToken = transferModelToken
        self.exitButtonTextColor = exitButtonTextColor
    }
    
    func getThemeColor() -> UIColor {
        self.themeColor
    }
    
    func getPartnerName() -> String {
        self.partnerName
    }
    
    // API for Transfer Complete
    func apiForConnectTranserComplete(completionHandler: @escaping (Bool, String?) -> Void) {
        
        guard let connectTranserCompleteURL = self.getURLForConnectTranserComplete() else {
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
        
        
        let headers = ["authorization": "Bearer " + (transferModelToken!)]
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
            
            if(response != nil){
                let httpUrlResponse:HTTPURLResponse = response as! HTTPURLResponse
                // handle data
                if(httpUrlResponse.statusCode == 200){
                    DispatchQueue.main.async {
                        completionHandler(true,"Successfully completed transfer")
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
    
    
    func getURLForConnectTranserComplete() -> URL? {
        
        guard let pdsBaseURLString = self.pdsBaseURLString else {
            return nil
        }
        let transferModelURL = "\(pdsBaseURLString)\(connectTransferCompleteAPIPath)"
        return URL(string: transferModelURL)
    }
    
}
