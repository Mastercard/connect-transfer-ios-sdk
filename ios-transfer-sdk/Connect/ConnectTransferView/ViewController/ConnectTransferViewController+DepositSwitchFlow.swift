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
extension ConnectTransferViewController {
    
    func openDepositSwitchFlow() {
        guard let config = self.transferViewModel.getTransferConfig() else {
            return
        }
        
        Atomic.presentTransact(from: self, config: config) { [weak self] interaction in
            
            guard let weakSelf = self else {return}
            
            weakSelf.handleInteractionEvents(interaction: interaction)

        } onCompletion: { [weak self] result in
            
            guard let weakSelf = self else {return}
            
            weakSelf.handleCompletionEvents(result: result)
        }
    }
    
    func handleInteractionEvents(interaction: TransactInteraction) {
        print("Interaction event: \(interaction.name)")
        
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
    
    func handleCompletionEvents(result: TransactResponse) {
        
        switch result {
            
        case .finished(let response):
            print("Finish event:")
            self.delegate?.onTransferEnd(self.transferViewModel.getResponseForFinish(responseData: response))
        
        case .closed(let response):
            print("Close event:")
            self.delegate?.onTransferEnd(self.transferViewModel.getResponseForDone(isError: true, reason: "exit"))
            
        case .error(let error):
            print("Transact returned with error:")
            self.delegate?.onTransferEnd(self.transferViewModel.getResponseForDone(isError: true, reason: error.localizedDescription))
            
        default:
            print("Default")
        }
        
        self.navigationController?.dismiss(animated: true)
    }
}


