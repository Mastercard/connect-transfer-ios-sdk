//
//  FailureViewController.swift
//  Connect
//
//  Created by Prathamesh Salawkar on 06/08/24.
//  Copyright © 2024 finicity. All rights reserved.
//

import UIKit
import AtomicTransact
import SafariServices

protocol FailureEventDelegate: AnyObject {
    func didTryAgain()
    func didReturnToPartnerOrExit(errorCode: String?)
}

class FailureViewController: UIViewController {
    
    //MARK: - FailureViewControllerState
    enum FailureViewControllerState: String {
      case FailureViewExitState, FailureViewRetryState
    }
    
    //MARK: - Outlets
    @IBOutlet weak var parentViewWidth: NSLayoutConstraint!
    @IBOutlet weak var parentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var failureNavigationView: NavigationView!
    @IBOutlet weak var poweredByView: PoweredByView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var tryAgainButton: UIButton!
    @IBOutlet weak var returnToPartnerOrExitButton: UIButton!
    
    //MARK: - Variables
    var failureViewModel: FailureViewModel
    weak var delegate: FailureEventDelegate?
    var failureViewControllerState: FailureViewControllerState?
    
    //MARK: - Init Methods
    init(partnerName: String?, themeColor: UIColor, errorModel: ErrorModel?, failureViewControllerState: FailureViewControllerState) {
        self.failureViewModel = FailureViewModel(partnerName: partnerName, themeColor: themeColor, errorModel: errorModel)
        super.init(nibName: "FailureViewController", bundle: nil)
        self.failureViewControllerState = failureViewControllerState
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Overriden Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    //MARK: - Actions
    @IBAction func returnToButtonAction(_ sender: Any) {
        self.delegate?.didReturnToPartnerOrExit(errorCode: self.failureViewModel.getErrorModelCode())
        self.navigationController?.dismiss(animated: true)
    }
    
    @IBAction func tryAgainButtonAction(_ sender: Any) {
        self.delegate?.didTryAgain()
        self.navigationController?.popViewController(animated: false)
    }
    
    //MARK: - Private Methods
    private func setUpViews() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.setUpParentViewDimension()
        self.setUpFailureNavigationView()
        self.setUpFailureTitleLabel()
        self.setUpFailureDescription()
        self.setUpReturnToButton()
        self.setUpTryAgainButton()
    }
    
    private func setUpParentViewDimension() {
        if Helper.isCurrentDeviceiPhone() {
            self.parentViewWidth.constant = UIApplication.shared.getParentViewSizeForiPhone().width
            self.parentViewHeight.constant = UIApplication.shared.getParentViewSizeForiPhone().height
            
        }else {
            self.parentViewWidth.constant = Helper.returnFinalSizeForIpad().width
            self.parentViewHeight.constant = Helper.returnFinalSizeForIpad().height
        }
    }
    
    @objc func dismissFailureVC() {
        guard let navigationController = self.navigationController else {
            return
        }
        
        DispatchQueue.main.async {
            let exitPopUpViewController = ExitPopUpViewController(currentNavigationController: navigationController, partnerName: self.failureViewModel.getPartnerName(), themeColor: self.failureViewModel.getThemeColor())
            exitPopUpViewController.modalPresentationStyle = .overCurrentContext
            exitPopUpViewController.delegate = self
            self.present(exitPopUpViewController, animated: true)
        }
    }
    
    private func setUpFailureNavigationView() {
        
        self.failureNavigationView.backButton.isHidden = true
        self.failureNavigationView.closeButton.isHidden = self.failureViewControllerState == .FailureViewExitState
        
        self.failureNavigationView.closeButtonCallback = {[weak self] in
            guard let weakSelf = self else {return}
            weakSelf.dismissFailureVC()
        }
    }
    
    private func setUpFailureTitleLabel() {
        self.titleLabel.text = FailureViewControllerUtil.getFailureTitleText()
        self.titleLabel.font = UIFont.systemFont(ofSize: 21.33, weight: .bold)
        self.titleLabel.textColor = FailureViewControllerUtil.getFailureTitleTextColor()
    }
    
    private func setUpFailureDescription() {
        self.descriptionLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        self.descriptionLabel.textColor = FailureViewControllerUtil.getFailureTitleTextColor()
        
        if let errorMsg = self.failureViewModel.getErrorModelMessage() {
            self.descriptionLabel.text = errorMsg
        }else {
            self.descriptionLabel.text = FailureViewControllerUtil.getFailureDescriptionText()
        }
    }
    
    private func setUpTryAgainButton() {
        self.tryAgainButton.backgroundColor = self.failureViewModel.getThemeColor()
        self.tryAgainButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        self.tryAgainButton.setTitle(FailureViewControllerUtil.getTryAgainText(), for: .normal)
        self.tryAgainButton.setTitleColor(self.failureViewModel.getReturnToButtonTitleTextColor(), for: .normal)
    }
    
    
    private func setUpReturnToButton() {
        if( self.failureViewControllerState == FailureViewControllerState.FailureViewRetryState){
            self.returnToPartnerOrExitButton.backgroundColor = self.failureViewModel.getReturnToButtonTitleTextColor()
            self.returnToPartnerOrExitButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            self.returnToPartnerOrExitButton.setTitle(String(format: FailureViewControllerUtil.getReturnToButtonText(), self.failureViewModel.getPartnerName()), for: .normal)
            self.returnToPartnerOrExitButton.setTitleColor(self.failureViewModel.getThemeColor(), for: .normal)
            self.returnToPartnerOrExitButton.setBorder(borderRadius: 1, borderColor: self.failureViewModel.getThemeColor())
            self.tryAgainButton.isHidden = false
        }
        else{
            self.returnToPartnerOrExitButton.backgroundColor = self.failureViewModel.getThemeColor()
            self.returnToPartnerOrExitButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            self.returnToPartnerOrExitButton.setTitle(FailureViewControllerUtil.getExitText(), for: .normal)
            self.returnToPartnerOrExitButton.setTitleColor(self.failureViewModel.getReturnToButtonTitleTextColor(), for: .normal)
            self.tryAgainButton.isHidden = true
        }
    }
    
}

//MARK: - Exit PopUp Delegate Methods
extension FailureViewController: ExitPopUpDelegate {
    func exitConnectTransfer() {
        guard let currentNavigationController = self.navigationController else {
            return
        }
        
        guard let rootViewController = currentNavigationController.viewControllers.first as? ConnectTransferViewController else {
            return
        }
        
        rootViewController.exitConnectTransfer()
    }
    
}
