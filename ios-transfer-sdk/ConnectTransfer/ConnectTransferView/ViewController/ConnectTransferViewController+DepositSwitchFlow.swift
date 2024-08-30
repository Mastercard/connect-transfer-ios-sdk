//
//  ConnectTransferViewController+DepositSwitchFlow.swift
//  Connect
//
//  Created by Anupam Kumar on 16/08/24.
//  Copyright © 2024 finicity. All rights reserved.
//

import AtomicTransact
import UIKit

//MARK: - Transfer Flow
extension ConnectTransferViewController: RedirectViewDelegate {
    
    func handleInteractionEvents(interaction: TransactInteraction) {
        
        switch interaction.name {
            
        case AtomicEvents.INITIALIZED_TRANSACT.rawValue:
            self.delegate?.onInitializeDepositSwitch(self.transferViewModel.getResponseForInitializeDepositSwitch(productType: interaction.product))
            
        default:
            guard let atomicEvent = AtomicEvents(rawValue: interaction.name) else {
                return
            }
            self.delegate?.onUserEvent(self.transferViewModel.getUserEventDict(event: atomicEvent, interactionResponse: interaction))
        
        }
    }
    
    func handleFinishedEvents(response: AtomicTransact.TransactResponse.ResponseData) {
        self.delegate?.onTransferEnd(self.transferViewModel.getResponseForFinish(responseData: response))
    }
    
    func handleClosedEvents(response: AtomicTransact.TransactResponse.ResponseData) {
        var reason = response.reason
        if let failReason = response.data["failReason"] as? String, failReason.count > 0 {
            reason = failReason
        }
        self.delegate?.onTransferEnd(self.transferViewModel.getResponseForClose(reason: reason))
    }
    
}


