//
//  ConnectTransferViewModel.swift
//  Connect
//
//  Created by Anupam Kumar on 31/07/24.
//  Copyright © 2024 finicity. All rights reserved.
//

import UIKit
import Combine
import AtomicTransact

class ConnectTransferViewModel: NSObject {
    
    private var transferModel: TransferModel? = nil
    private let pdsAPIPath = "server/authenticate/v2/transfer/deposit-switch"
    private let pdsTermsAndConditionAPIPath = "server/terms-and-policies"
    private var transferEventCommonDataDict: NSDictionary?
    private var pdsBaseURLString: String?
    private var connectTransferURLString: String
    private var errorModel: ErrorModel? = nil
    
    init(connectTransferURLString: String) {
        self.connectTransferURLString = connectTransferURLString
        super.init()
    }
    
    func getThemeColor() -> UIColor {
        return UIColor(red: 207/255, green: 69/255, blue: 0, alpha: 1.0)
    }
    
    func getPartnerName() -> String {
        return transferModel?.transferData?.metadata?.applicationName ?? ""
    }
    
    func getTransferModel() -> TransferModel? {
        self.transferModel
    }
    
    func getErrorModel() -> ErrorModel? {
        self.errorModel
    }
    
    func getNextButtonTitleTextColor() -> UIColor {
        .white
    }
    
    func apiHitToGetTransferModel(completionHandler: @escaping (Bool) -> Void) {
                
        guard let transferModelURL = self.getURLForTransferModelAPI(currentURLString: self.connectTransferURLString) else {
            completionHandler(false)
            return
        }
                
        var urlRequest = URLRequest(url: transferModelURL)
        urlRequest.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            
            guard let httpResponse = response as? HTTPURLResponse else {
                self.setTransferEventCommonDataDict(fullPDSURL: transferModelURL)
                completionHandler(false)
                return
            }
            
            switch httpResponse.statusCode {
                
            case 200, 201:
                
                if let responseData = data, let transferModel = try? JSONDecoder().decode(TransferModel.self, from: responseData) {
                    self.transferModel = transferModel
                    self.setTransferEventCommonDataDict(fullPDSURL: transferModelURL)
                    
                    completionHandler(true)
                    
                }else {
                    completionHandler(false)
                }
                
                break
                
            default:
                self.setTransferEventCommonDataDict(fullPDSURL: transferModelURL)
                if let responseData = data, let errorModel = try? JSONDecoder().decode(ErrorModel.self, from: responseData) {
                    self.errorModel = errorModel
                    
                    completionHandler(false)
                    
                }else {
                    completionHandler(false)
                }
            }
            
        }.resume()
        
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

        self.pdsBaseURLString = "https://\(host)/"    
        if let port = currentURL.port {
            self.pdsBaseURLString = "http://\(host):\(port)/"
        }
        
        let transferModelURL = "\(self.pdsBaseURLString!)\(pdsAPIPath)?\(queryParams)"
        setUpAppLanguage(currentURLString: currentURLString)
        
        return URL(string: transferModelURL)
    }
    
    func getPDSBaseURLString() -> String? {
        self.pdsBaseURLString
    }
    
}

//MARK: - App Language Get Set Methods
extension ConnectTransferViewModel {
    private func setUpAppLanguage(currentURLString: String) {
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
    
    // API for terms and conditions
    func apiForTermsAndConditionConsent(completionHandler: @escaping (Bool, String?) -> Void) {
        
        guard let termsAndConditionURL = self.getURLTermsAndConditionConsentAPI() else {
            completionHandler(false, nil)
            return
        }
        
       
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let dateObj:Date = Date()
        let currentDateAndTime = dateFormatter.string(from: dateObj)
                
        let parameters : [String:Any] = ["context":"partner","workflow": "CONNECT_PDS","language":"en-US","termsAndConditionsAcceptedDate":currentDateAndTime,"privacyPolicyAcceptedDate":currentDateAndTime]

        
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
    
    func getURLTermsAndConditionConsentAPI() -> URL? {
        guard let pdsBaseURLString = pdsBaseURLString else { return nil }
        let transferModelURL = "\(pdsBaseURLString)\(pdsTermsAndConditionAPIPath)"
        return URL(string: transferModelURL)
    }
}

//MARK: - Connect Transfer Event Methods
extension ConnectTransferViewModel {
    
    private func setTransferEventCommonDataDict(fullPDSURL: URL) {
        
        guard let urlComponent = URLComponents(url: fullPDSURL, resolvingAgainstBaseURL: false) else {
            return
        }
        
        var queryItems: [String : String] = [:]
        
        for item in urlComponent.queryItems ?? [] {
            
            if let customerId = item.getQueryValue(for: TransferEventDataName.customerId.rawValue) {
                queryItems[TransferEventDataName.customerId.rawValue] = customerId
            }
            
            if let partnerId = item.getQueryValue(for: TransferEventDataName.partnerId.rawValue) {
                queryItems[TransferEventDataName.partnerId.rawValue] = partnerId
            }
            
            if let timestamp = item.getQueryValue(for: TransferEventDataName.timestamp.rawValue) {
                queryItems[TransferEventDataName.timestamp.rawValue] = timestamp
            }
            
            if let ttl = item.getQueryValue(for: TransferEventDataName.ttl.rawValue) {
                queryItems[TransferEventDataName.ttl.rawValue] = ttl
            }
            
            if let type = item.getQueryValue(for: TransferEventDataName.type.rawValue) {
                queryItems[TransferEventDataName.type.rawValue] = type
            }
            
            if let sessionId = item.getQueryValue(for: "signature") {
                queryItems[TransferEventDataName.sessionId.rawValue] = sessionId
            }
            
        }
        
        if let experience = self.transferModel?.transferData?.experience, let experienceId = experience.id {
            queryItems[TransferEventDataName.experience.rawValue] = experienceId
        }
        
        self.transferEventCommonDataDict = queryItems as NSDictionary
        
    }
    
    func getTransferEventCommonDataDict() -> NSDictionary? {
        
        self.transferEventCommonDataDict
    }
    
    func getResponseForInitializeTransfer() -> NSDictionary? {
        guard var commonResponse = getTransferEventCommonDataDict() as? [String: String] else {
            return nil
        }
        
        commonResponse[TransferEventDataName.action.rawValue] = UserEvents.INITIALIZE_TRANSFER.rawValue
        
        return commonResponse as NSDictionary
    }
    
    func getResponseForTermsAndConditionsAccepted() -> NSDictionary? {
        guard var commonResponse = getTransferEventCommonDataDict() as? [String: String] else {
            return nil
        }
        
        commonResponse[TransferEventDataName.action.rawValue] = UserEvents.TERMS_ACCEPTED.rawValue
        
        return commonResponse as NSDictionary
    }
    
    func getResponseForInitializeDepositSwitch(productType: AtomicTransact.AtomicConfig.ProductType?) -> NSDictionary? {
        guard var commonResponse = getTransferEventCommonDataDict() as? [String: String] else {
            return nil
        }
        
        commonResponse[TransferEventDataName.action.rawValue] = UserEvents.INITIALIZE_DEPOSIT_SWITCH.rawValue
        
        if let productType = productType {
            commonResponse[TransferEventDataName.product.rawValue] = productType.rawValue
        }
        
        return commonResponse as NSDictionary
    }
    
    func getResponseForClose(reason: String?, errorCode: String? = nil) -> NSDictionary? {
        guard var commonResponse = getTransferEventCommonDataDict() as? [String: Any] else {
            return nil
        }
        
        commonResponse[TransferEventDataName.action.rawValue] = UserEvents.END.rawValue
        
        if reason == RedirectReason.UNKNOWN.rawValue ||  reason == RedirectReason.EXIT.rawValue {
            commonResponse[TransferEventDataName.reason.rawValue] = RedirectReason.EXIT.rawValue
            commonResponse[TransferEventDataName.code.rawValue] = "100"
            
        }else {
            commonResponse[TransferEventDataName.reason.rawValue] = reason
            commonResponse[TransferEventDataName.code.rawValue] = errorCode != nil ? errorCode! : "500"
        }
        
        return commonResponse as NSDictionary
    }
    
    func getResponseForFinish(responseData: AtomicTransact.TransactResponse.ResponseData) -> NSDictionary? {
        guard var commonResponse = getTransferEventCommonDataDict() as? [String: Any] else {
            return nil
        }
        
        commonResponse[TransferEventDataName.action.rawValue] = UserEvents.END.rawValue
        commonResponse[TransferEventDataName.reason.rawValue] = RedirectReason.COMPLETE.rawValue
        commonResponse[TransferEventDataName.code.rawValue] = "200"
        
        let dict = commonResponse.merging(responseData.data) { _, _ in }
        
        return dict as NSDictionary
    }
    
    func getUserEventDict(event: AtomicEvents, interactionResponse: TransactInteraction) -> NSDictionary? {
        
        guard var commonResponse = getTransferEventCommonDataDict() as? [String: Any] else {
            return nil
        }
        
        switch event {
            
        case .SEARCH_BY_COMPANY:
            commonResponse[TransferEventDataName.action.rawValue] = UserEvents.SEARCH_PAYROLL_PROVIDER.rawValue
            commonResponse[TransferEventDataName.searchTerm.rawValue] = interactionResponse.value["query"]
            
        case .SELECTED_COMPANY_FROM_SEARCH_BY_COMPANY_PAGE:
            commonResponse[TransferEventDataName.action.rawValue] = UserEvents.SELECT_PAYROLL_PROVIDER.rawValue
            commonResponse[TransferEventDataName.payrollProvider.rawValue] = interactionResponse.value["company"]
            
        case .CLICKED_CONTINUE_FROM_FORM_ON_LOGIN_PAGE, .CLICKED_CONTINUE_FROM_FORM_ON_INTERRUPT_PAGE:
            commonResponse[TransferEventDataName.action.rawValue] = UserEvents.SUBMIT_CREDENTIALS.rawValue
            commonResponse[TransferEventDataName.inputType.rawValue] = interactionResponse.value["input"]
            
        case .CLICKED_EXTERNAL_LOGIN_RECOVERY_LINK_FROM_LOGIN_HELP_PAGE:
            commonResponse[TransferEventDataName.action.rawValue] = UserEvents.EXTERNAL_LINK.rawValue
            commonResponse[TransferEventDataName.buttonName.rawValue] = interactionResponse.value["button"]
            
        case .CLICKED_CONTINUE_FROM_PERCENTAGE_DEPOSIT_AMOUNT_PAGE, .CLICKED_CONTINUE_FROM_FIXED_DEPOSIT_AMOUNT_PAGE:
            commonResponse[TransferEventDataName.action.rawValue] = UserEvents.CHANGE_DEFAULT_ALLOCATION.rawValue
            commonResponse[TransferEventDataName.depositOption.rawValue] = interactionResponse.value["distributionType"]
            commonResponse[TransferEventDataName.depositAllocation.rawValue] = interactionResponse.value["distributionAmount"]
            
        case .CLICKED_BUTTON_TO_START_AUTHENTICATION:
            commonResponse[TransferEventDataName.action.rawValue] = UserEvents.SUBMIT_ALLOCATION.rawValue
            commonResponse[TransferEventDataName.depositOption.rawValue] = interactionResponse.value["distributionType"]
            commonResponse[TransferEventDataName.depositAllocation.rawValue] = interactionResponse.value["distributionAmount"]
            
        case .VIEWED_TASK_COMPLETED_PAGE:
            commonResponse[TransferEventDataName.action.rawValue] = UserEvents.TASK_COMPLETED.rawValue
            commonResponse[TransferEventDataName.status.rawValue] = interactionResponse.value["state"]
            
        case .VIEWED_ACCESS_UNAUTHORIZED_PAGE:
            commonResponse[TransferEventDataName.action.rawValue] = UserEvents.UNAUTHORIZED.rawValue
            commonResponse[TransferEventDataName.expired.rawValue] = false
            
        case .VIEWED_EXPIRED_TOKEN_PAGE:
            commonResponse[TransferEventDataName.action.rawValue] = UserEvents.UNAUTHORIZED.rawValue
            commonResponse[TransferEventDataName.expired.rawValue] = true
            
        default:
            break
            
        }
        
        return commonResponse as NSDictionary
    }
}
