//
//  ConnectTransferRedirectViewModel.swift
//  Connect
//
//  Created by Anupam Kumar on 09/08/24.
//  Copyright © 2024 finicity. All rights reserved.
//

import UIKit
import AtomicTransact

class ConnectTransferRedirectViewModel: NSObject {

    private var themeColor: UIColor
    private var pdsBaseURLString: String?
    private var exitButtonTextColor: UIColor
    private let connectTransferCompleteAPIPath = "server/auto/v2/complete"
    private var transferModel: TransferModel? = nil
    
    init(themeColor: UIColor, pdsBaseURLString: String?, transferModel: TransferModel?, exitButtonTextColor: UIColor = .white) {
        self.themeColor = themeColor
        self.pdsBaseURLString = pdsBaseURLString
        self.transferModel = transferModel
        self.exitButtonTextColor = exitButtonTextColor
    }
    
    func getThemeColor() -> UIColor {
        self.themeColor
    }
    
    func getPartnerName() -> String {
        return transferModel?.transferData?.metadata?.applicationName ?? ""
    }
    
    func getTransferModelTokenString() -> String? {
        self.transferModel?.token
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
        
        let headers = ["authorization": "Bearer " + (getTransferModelTokenString()!)]
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
    
    private func getTransferToken() -> String? {
        self.transferModel?.transferData?.userToken
    }
    
    private func getTransferProductType() -> AtomicConfig.ProductType? {

        guard let productType = self.transferModel?.transferData?.product else {
            return nil
        }

        return AtomicConfig.ProductType(rawValue: productType)
    }

    private func getMetaDataDict() -> [String: String]? {
        self.transferModel?.transferData?.metadata?.getMetaDataDict()
    }
    
}

//MARK: - Deposit Switch Flow Config Methods
extension ConnectTransferRedirectViewModel {
    
    func getTransferConfig() -> AtomicConfig? {

        guard let publicToken = self.getTransferToken() else {
            return nil
        }

        guard let product = self.getTransferProductType() else {
            return nil
        }
        
        let config = AtomicConfig(publicToken: publicToken, scope: .userLink, tasks: [.init(operation: product)], theme: .init(brandColor: self.getThemeColor(), dark: .light), language: Helper.getCurrentAppLanguage(), metadata: getMetaDataDict(), customer: AtomicConfig.Customer.init(name: getPartnerName()))

        return config
    }
}
