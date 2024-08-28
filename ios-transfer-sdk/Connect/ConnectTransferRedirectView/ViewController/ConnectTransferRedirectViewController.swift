//
//  ConnectTransferRedirectViewController.swift
//  Connect
//
//  Created by Anupam Kumar on 29/07/24.
//  Copyright © 2024 finicity. All rights reserved.
//

import UIKit

class ConnectTransferRedirectViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var parentViewOfRedirectVC: UIView!
    @IBOutlet weak var navigationView: NavigationView!
    @IBOutlet weak var tickMarkOfRedirect: UIImageView!
    @IBOutlet weak var redirectingTextLabel: UILabel!
    @IBOutlet weak var loaderImageView: UIImageView!
    @IBOutlet weak var poweredByView: PoweredByView!
    @IBOutlet weak var parentViewWidth: NSLayoutConstraint!
    @IBOutlet weak var parentViewHeight: NSLayoutConstraint!
    
    //MARK: - Variables
    private var redirectViewModel: ConnectTransferRedirectViewModel
    var callbackForTransferFlowComplete:(()->Void)?
    
    //MARK: - Init Methods
    init(partnerName: String, themeColor: UIColor, pdsBaseURLString: String?, transferModelToken: String?) {
        self.redirectViewModel = ConnectTransferRedirectViewModel(partnerName: partnerName, themeColor: themeColor, pdsBaseURLString: pdsBaseURLString, transferModelToken: transferModelToken)
        super.init(nibName: "ConnectTransferRedirectViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Overriden Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpParentViewDimension()
        setUpNavigationView()
        setUpRedirectingLabel()
        setUpLoaderTheme()
        apiHitToCompleteTheTransferFlow()
    }
    
    deinit {
        self.loaderImageView.removeAllAnimations()
    }

    //MARK: - Class Methods
    private func setUpParentViewDimension() {
        if Helper.isCurrentDeviceiPhone() {
            self.parentViewWidth.constant = UIApplication.shared.getParentViewSizeForiPhone().width
            self.parentViewHeight.constant = UIApplication.shared.getParentViewSizeForiPhone().height
            
        }else {
            self.parentViewWidth.constant = Helper.returnFinalSizeForIpad().width
            self.parentViewHeight.constant = Helper.returnFinalSizeForIpad().height
        }
    }
    
    private func setUpNavigationView() {
        
        self.navigationView.backButtonCallback = {[weak self] in
            guard let weakSelf = self else {return}
            weakSelf.navigationController?.popViewController(animated: true)
        }
        
        self.navigationView.closeButtonCallback = {[weak self] in
            guard let weakSelf = self else {return}
            weakSelf.dismissConnectTransferFlow()
        }
    }
    
    private func setUpLoaderTheme() {
        self.loaderImageView.removeAllAnimations()
        self.loaderImageView.image = UIImage(named: "loader")?.renderAlwaysWithTemplateMode()
        self.loaderImageView.tintColor = self.redirectViewModel.getThemeColor()
        loaderImageView.setLayerRotationToInfinite()
    }
    
    private func setUpRedirectingLabel() {
        redirectingTextLabel.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        redirectingTextLabel.textColor = TransferViewControllerUtil.getRedirectingTextColor()
        redirectingTextLabel.text = TransferViewControllerUtil.getRedirectingText()
    }
    
    @objc func dismissConnectTransferFlow() {
        
        guard let navigationController = self.navigationController else {
            return
        }
        
        DispatchQueue.main.async {
            let exitPopUpViewController = ExitPopUpViewController(currentNavigationController: navigationController, partnerName: self.redirectViewModel.getPartnerName(), themeColor: self.redirectViewModel.getThemeColor())
            exitPopUpViewController.modalPresentationStyle = .overCurrentContext
            exitPopUpViewController.delegate = self
            self.present(exitPopUpViewController, animated: true)
        }
    }
    
    func apiHitToCompleteTheTransferFlow() {
        self.redirectViewModel.apiForConnectTranserComplete { _, _ in
            if let callbackForTransferFlowComplete = self.callbackForTransferFlowComplete {
                callbackForTransferFlowComplete()
            }
        }
    }
}

//MARK: - Exit PopUp Delegate Methods
extension ConnectTransferRedirectViewController: ExitPopUpDelegate {
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
