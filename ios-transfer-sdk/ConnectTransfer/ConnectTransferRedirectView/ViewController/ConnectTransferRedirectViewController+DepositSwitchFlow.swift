//
//  ConnectTransferRedirectViewController+DepositSwitchFlow.swift
//  ConnectTransfer
//
//  Created by Anupam Kumar on 30/08/24.
//  Copyright © 2024 finicity. All rights reserved.
//

import UIKit
import AtomicTransact

//MARK: - Protocol
protocol RedirectViewDelegate: AnyObject {
    func handleInteractionEvents(interaction: TransactInteraction)
    func handleFinishedEvents(response: TransactResponse.ResponseData)
    func handleClosedEvents(response: TransactResponse.ResponseData)
}

//MARK: - Deposit Switch Flow
extension ConnectTransferRedirectViewController {
    
    func openDepositSwitchFlow() {
        guard let config = self.redirectViewModel.getTransferConfig() else {
            return
        }

        Atomic.presentTransact(from: self, config: config) { [weak self] interaction in

            guard let weakSelf = self else {return}

            weakSelf.delegate?.handleInteractionEvents(interaction: interaction)

        } onCompletion: { [weak self] result in

            guard let weakSelf = self else {return}

            weakSelf.handleCompletionEvents(result: result)
        }
    }
    
    func handleCompletionEvents(result: TransactResponse) {

        switch result {

        case .finished(let response):
            self.apiHitToCompleteTheTransferFlow(isForFinished: true, response: response)

        case .closed(let response):
            self.apiHitToCompleteTheTransferFlow(isForFinished: false, response: response)

        case .error(_):
            openFailureVC()

        default:
            break
        }
    }
    
    func openFailureVC() {
        DispatchQueue.main.async {
            let failureVC = FailureViewController(partnerName: self.redirectViewModel.getPartnerName(), themeColor: self.redirectViewModel.getThemeColor(), errorModel: nil, failureViewControllerState: .FailureViewRetryState)
            failureVC.delegate = self
            self.navigationController?.pushViewController(failureVC, animated: true)
        }
    }
    
    func apiHitToCompleteTheTransferFlow(isForFinished: Bool, response: TransactResponse.ResponseData) {
        self.redirectViewModel.apiForConnectTranserComplete { _, _ in
            
            if isForFinished {
                self.delegate?.handleFinishedEvents(response: response)
                
            }else {
                self.delegate?.handleClosedEvents(response: response)
            }
            
            DispatchQueue.main.async {
                self.navigationController?.dismiss(animated: true)
            }
        }
    }
}

//MARK: - FailureEventDelegate Method
extension ConnectTransferRedirectViewController: FailureEventDelegate {
    func didReturnToPartnerOrExit(errorCode: String?) {
        guard let currentNavigationController = self.navigationController else {
            return
        }
        
        guard let rootViewController = currentNavigationController.viewControllers.first as? ConnectTransferViewController else {
            return
        }
        
        rootViewController.didReturnToPartnerOrExit(errorCode: errorCode)
    }
    
    func didTryAgain() {
        loaderImageView.setLayerRotationToInfinite()
        self.openDepositSwitchFlow()
    }
    
}
