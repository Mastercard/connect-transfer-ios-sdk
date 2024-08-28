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

public protocol FailureEventDelegate: AnyObject {
    func didTryAgain()
    func didReturn(error: String)
}

public class FailureViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var parentViewWidth: NSLayoutConstraint!
    @IBOutlet weak var parentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var failureNavigationView: NavigationView!
    @IBOutlet weak var poweredByView: PoweredByView!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var tryAgainButton: UIButton!
    @IBOutlet weak var returnToButton: UIButton!
    
    //MARK: - Variables
    var failureViewModel: FailureViewModel
    weak var delegate: FailureEventDelegate?
    
    //MARK: - Init Methods
    init(partnerName: String, themeColor: UIColor) {
        self.failureViewModel = FailureViewModel(partnerName: partnerName, themeColor: themeColor)
        super.init(nibName: "FailureViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Overriden Methods
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
  
    //MARK: - Actions
    @IBAction func returnToButtonAction(_ sender: Any) {
        
    }
    
    @IBAction func tryAgainButtonAction(_ sender: Any) {
    }
    
    //MARK: - Public Methods
    public func loadConnectFailure(with urlString: String){
        
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
            self.present(exitPopUpViewController, animated: true)
        }
    }
    
    private func setUpFailureNavigationView() {
        
        self.failureNavigationView.backButton.isHidden = true
        
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
        self.descriptionLabel.text = FailureViewControllerUtil.getFailureDescriptionText()
        self.descriptionLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        self.descriptionLabel.textColor = FailureViewControllerUtil.getFailureTitleTextColor()
    }
    
    private func setUpTryAgainButton() {
        self.tryAgainButton.backgroundColor = self.failureViewModel.getThemeColor()
        self.tryAgainButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        self.tryAgainButton.setTitle(FailureViewControllerUtil.getTryAgainText(), for: .normal)
        self.tryAgainButton.setTitleColor(self.failureViewModel.getReturnToButtonTitleTextColor(), for: .normal)
    }
    
    
    private func setUpReturnToButton() {
        self.returnToButton.backgroundColor = self.failureViewModel.getReturnToButtonTitleTextColor()
        self.returnToButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        self.returnToButton.setTitle(String(format: FailureViewControllerUtil.getReturnToButtonText(), self.failureViewModel.getPartnerName()), for: .normal)
        self.returnToButton.setTitleColor(self.failureViewModel.getThemeColor(), for: .normal)
        self.returnToButton.setBorder(borderRadius: 1, borderColor: self.failureViewModel.getThemeColor())
    }
    
}
