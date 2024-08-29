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
            self.openRedirectVC(responseData: response)
        
        case .closed(_):
            self.delegate?.onTransferEnd(self.transferViewModel.getResponseForDone(isError: true, reason: "exit"))
            self.navigationController?.dismiss(animated: true)
            
        case .error(let error):
            self.delegate?.onTransferEnd(self.transferViewModel.getResponseForDone(isError: true, reason: error.localizedDescription))
            self.navigationController?.dismiss(animated: true)
            
        default:
            break
        }
    }
    
    func openRedirectVC(responseData: AtomicTransact.TransactResponse.ResponseData) {
        DispatchQueue.main.async {
            let connectTransferRedirectViewController = ConnectTransferRedirectViewController(partnerName: self.transferViewModel.getPartnerName(), themeColor: self.transferViewModel.getThemeColor(), pdsBaseURLString: self.transferViewModel.getPDSBaseURLString(), transferModelToken: self.transferViewModel.getTransferModelTokenString())
            self.navigationController?.pushViewController(connectTransferRedirectViewController, animated: false)
            
            connectTransferRedirectViewController.callbackForTransferFlowComplete = {[weak self] in
                
                guard let weakSelf = self else {return}
                weakSelf.delegate?.onTransferEnd(weakSelf.transferViewModel.getResponseForFinish(responseData: responseData))
                weakSelf.closeTransferFlow()
            
            }
        }
    }
    
    func closeTransferFlow() {
        DispatchQueue.main.async {
            self.navigationController?.dismiss(animated: true)
        }
    }
}


