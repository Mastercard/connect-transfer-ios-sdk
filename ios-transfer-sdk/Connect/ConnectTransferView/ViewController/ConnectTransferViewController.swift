//
//  ConnectTransferViewController.swift
//  Connect
//
//  Created by Anupam Kumar on 26/07/24.
//  Copyright © 2024 finicity. All rights reserved.
//

import UIKit
import AtomicTransact
import SafariServices

public protocol ConnectTransferEventDelegate: AnyObject {
    func didLoadDone()
    func didCloseWithError(error: String)
}

public class ConnectTransferViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var parentViewWidth: NSLayoutConstraint!
    @IBOutlet weak var parentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var transferNavigationView: NavigationView!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var transferDescriptionLabel: UILabel!
    
    @IBOutlet weak var step1View: UIView!
    @IBOutlet weak var step1Label: UILabel!
    @IBOutlet weak var step1InstructionLabel: UILabel!
    
    @IBOutlet weak var step2View: UIView!
    @IBOutlet weak var step2Label: UILabel!
    @IBOutlet weak var step2InstructionLabel: UILabel!

    @IBOutlet weak var step3View: UIView!
    @IBOutlet weak var step3Label: UILabel!
    @IBOutlet weak var step3InstructionLabel: UILabel!
    
    @IBOutlet weak var step4View: UIView!
    @IBOutlet weak var step4Label: UILabel!
    @IBOutlet weak var step4InstructionLabel: UILabel!
    
    @IBOutlet weak var termsAndCondtionText: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    //MARK: - Variables
    var transferViewModel = ConnectTransferViewModel()
    var safariWebView: SFSafariViewController? = nil
    weak var delegate: ConnectTransferEventDelegate?
    
    //MARK: - Overriden Methods
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    //MARK: - Actions
    @IBAction func nextButtonAction(_ sender: Any) {
        
        self.transferViewModel.apiForTermsAndConditionConsent() { (isSuccess, error) in
            
            if isSuccess {
                
            }
            
            else {
            }
        }
        
        DispatchQueue.main.async {
            let connectTransferRedirectViewController = ConnectTransferRedirectViewController(partnerName: self.transferViewModel.getPartenrName(), themeColor: self.transferViewModel.getThemeColor())
            self.navigationController?.pushViewController(connectTransferRedirectViewController, animated: true)
        }
    }
    
    //MARK: - Public Methods
    public func loadConnectTransfer(with urlString: String){
        
        self.transferViewModel.apiHitToGetTransferModel(urlString: urlString) { (isSuccess, error) in
            
            if isSuccess {
                self.delegate?.didLoadDone()
                
            }else {
                self.delegate?.didCloseWithError(error: error ?? "")
            }
        }
    }
    
    //MARK: - Private Methods
    private func setUpViews() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.setUpParentViewDimension()
        self.setUpTransferNavigationView()
        self.setUpTransferTitleLabel()
        self.setUpTransferDescription()
        self.setUpStepsView()
        self.setUpTermsAndConditonsText()
        self.setUpNextButton()
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
    
    @objc func dismissTransferVC() {
        
        guard let navigationController = self.navigationController else {
            return
        }
        
        DispatchQueue.main.async {
            let exitPopUpViewController = ExitPopUpViewController(currentNavigationController: navigationController, partnerName: self.transferViewModel.getPartenrName(), themeColor: self.transferViewModel.getThemeColor())
            exitPopUpViewController.modalPresentationStyle = .overCurrentContext
            self.present(exitPopUpViewController, animated: true)
        }
    }
    
    private func setUpTransferNavigationView() {
        
        self.transferNavigationView.backButtonCallback = {[weak self] in
            guard let weakSelf = self else {return}
            weakSelf.dismissTransferVC()
        }
        
        self.transferNavigationView.closeButtonCallback = {[weak self] in
            guard let weakSelf = self else {return}
            weakSelf.dismissTransferVC()
        }
    }
    
    private func setUpTransferTitleLabel() {
        self.titleLabel.text = TransferViewControllerUtil.getTransferTitleText()
        self.titleLabel.font = UIFont.systemFont(ofSize: 21.33, weight: .bold)
        self.titleLabel.textColor = TransferViewControllerUtil.getDefaultOnLightTextColor()
    }
    
    private func setUpTransferDescription() {
        let transferDescriptionMutableString = NSMutableAttributedString(string: String(format: TransferViewControllerUtil.getTransferDescriptionText(), self.transferViewModel.getPartenrName()), attributes: [NSAttributedString.Key.foregroundColor : TransferViewControllerUtil.getDefaultOnLightTextColor(), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
        
        let partenerNameRange = transferDescriptionMutableString.mutableString.range(of: self.transferViewModel.getPartenrName())
        
        transferDescriptionMutableString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .bold)], range: partenerNameRange)
        
        let atomicNameRange = transferDescriptionMutableString.mutableString.range(of: TransferViewControllerUtil.getAtomicText())
        
        transferDescriptionMutableString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .bold)], range: atomicNameRange)
        
        let finicityNameRange = transferDescriptionMutableString.mutableString.range(of: TransferViewControllerUtil.getFincityText())
        
        transferDescriptionMutableString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .bold)], range: finicityNameRange)
        
        self.transferDescriptionLabel.attributedText = transferDescriptionMutableString
    }
    
    private func setUpStepsView() {
        self.step1Label.setUpStepLabelAttributes(text: "1", themeColor: self.transferViewModel.getThemeColor())
        
        self.step1InstructionLabel.setUpStepInstructionAttribute(text: TransferViewControllerUtil.getTransferFirstStepText())
        
        self.step2Label.setUpStepLabelAttributes(text: "2", themeColor: self.transferViewModel.getThemeColor())
        
        self.step2InstructionLabel.setUpStepInstructionAttribute(text: TransferViewControllerUtil.getTransferSecondStepText())
        
        self.step3Label.setUpStepLabelAttributes(text: "3", themeColor: self.transferViewModel.getThemeColor())
        
        self.step3InstructionLabel.setUpStepInstructionAttribute(text: TransferViewControllerUtil.getTransferThirdStepText())
        
        self.step4Label.setUpStepLabelAttributes(text: "4", themeColor: self.transferViewModel.getThemeColor())
        
        self.step4InstructionLabel.setUpStepInstructionAttribute(text: String(format: TransferViewControllerUtil.getTransferFourthStepText(), self.transferViewModel.getPartenrName()))
    }
    
    private func setUpTermsAndConditonsText(){
        let transferTnCMutableString = NSMutableAttributedString(string: "\(TransferViewControllerUtil.getTransferTermsAndConditionsAndPrivacyText()) ", attributes: [NSAttributedString.Key.foregroundColor : TransferViewControllerUtil.getDefaultOnLightTextColor(), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)])
        
        let nextTextRange = transferTnCMutableString.mutableString.range(of: TransferViewControllerUtil.getNextButtonText())
        
        transferTnCMutableString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .bold)], range: nextTextRange)
        
        let termsAndConditonRange = transferTnCMutableString.mutableString.range(of: TransferViewControllerUtil.getTermsAndConditionsText())

        transferTnCMutableString.addAttributes([NSAttributedString.Key.foregroundColor: self.transferViewModel.getThemeColor(), NSAttributedString.Key.underlineStyle : 1, NSAttributedString.Key.underlineColor: self.transferViewModel.getThemeColor()], range: termsAndConditonRange)

        let privacyNoticeRange = transferTnCMutableString.mutableString.range(of: TransferViewControllerUtil.getPrivacyNoticeText())

        transferTnCMutableString.addAttributes([NSAttributedString.Key.foregroundColor: self.transferViewModel.getThemeColor(), NSAttributedString.Key.underlineStyle : 1, NSAttributedString.Key.underlineColor: self.transferViewModel.getThemeColor()], range: privacyNoticeRange)

        let redirectAttachment = NSTextAttachment()
        redirectAttachment.image = UIImage(named: "redirect_icon")?.renderAlwaysWithTemplateMode()
        redirectAttachment.bounds = CGRect(x: 0, y: -3, width: 13, height: 13)
        let redirectIconString = NSMutableAttributedString(attachment: redirectAttachment)
        redirectIconString.addAttribute(.foregroundColor, value: self.transferViewModel.getThemeColor(), range: redirectIconString.mutableString.range(of: redirectIconString.string))
        transferTnCMutableString.append(redirectIconString)
        
        self.termsAndCondtionText.attributedText = transferTnCMutableString
        self.termsAndCondtionText.isUserInteractionEnabled = true
        let tapGestureOfTnC = UITapGestureRecognizer(target: self, action: #selector(tappedOnLabel(_ :)))
        tapGestureOfTnC.numberOfTapsRequired = 1
        self.termsAndCondtionText.addGestureRecognizer(tapGestureOfTnC)
    }
    
    private func setUpNextButton() {
        self.nextButton.backgroundColor = self.transferViewModel.getThemeColor()
        self.nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        self.nextButton.setTitle(TransferViewControllerUtil.getNextButtonText(), for: .normal)
        self.nextButton.setTitleColor(self.transferViewModel.getNextButtonTitleTextColor(), for: .normal)
    }
    
    @objc private func tappedOnLabel(_ gesture: UITapGestureRecognizer) {
        
        guard let text = self.termsAndCondtionText.text else {
            return
        }
        
        let termsAndConditonRange = (text as NSString).range(of: TransferViewControllerUtil.getTermsAndConditionsText())
        
        let privacyPolicyRange = (text as NSString).range(of: TransferViewControllerUtil.getPrivacyNoticeText())
        
        if gesture.didTapAttributedTextInLabel(label: self.termsAndCondtionText, inRange: privacyPolicyRange) {
            self.loadURLInSafeContainer(urlString: Helper.getPrivacyPolicyURLString())
            
        } else if gesture.didTapAttributedTextInLabel(label: self.termsAndCondtionText, inRange: termsAndConditonRange){
            self.loadURLInSafeContainer(urlString: Helper.getTermsAndConditionsURLString())
            
        }
    }
    
    private func loadURLInSafeContainer(urlString: String) {
        
        guard Thread.isMainThread else {
            DispatchQueue.main.async {
                self.loadURLInSafeContainer(urlString: urlString)
            }
            return
        }
        
        guard let newURL = URL(string: urlString) else {
            return
        }
        
        if let safariWebView = self.safariWebView {
            safariWebView.dismiss(animated: true)
        }
        
        self.safariWebView = SFSafariViewController(url: newURL)
        self.safariWebView?.modalPresentationStyle = .overFullScreen
        self.safariWebView?.delegate = self
        
        self.present(self.safariWebView!, animated: true)
    }
}

//MARK: - SFSafariViewControllerDelegate Methods
extension ConnectTransferViewController: SFSafariViewControllerDelegate {
    public func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
        if self.safariWebView != nil {
            self.safariWebView = nil
        }
    }
}


//MARK: - UILabel Extension for Self View Controller
fileprivate extension UILabel {
    func setUpStepInstructionAttribute(text: String) {
        self.text = text
        self.font = UIFont.systemFont(ofSize: 13)
        self.textColor = TransferViewControllerUtil.getDefaultOnLightTextColor()
    }
    
    func setUpStepLabelAttributes(text: String, themeColor: UIColor) {
        self.text = text
        self.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        self.textColor = themeColor
    }
}
