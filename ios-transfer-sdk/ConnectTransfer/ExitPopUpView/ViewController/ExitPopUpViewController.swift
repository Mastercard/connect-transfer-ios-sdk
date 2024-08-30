//
//  ExitPopUpViewController.swift
//  Connect
//
//  Created by Anupam Kumar on 08/08/24.
//  Copyright © 2024 finicity. All rights reserved.
//

import UIKit

protocol ExitPopUpDelegate: AnyObject{
    func exitConnectTransfer()
}

class ExitPopUpViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var exitPopUpParentView: UIView!
    @IBOutlet weak var parentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var parentViewWidth: NSLayoutConstraint!
    @IBOutlet weak var exitPopUpView: UIView!
    @IBOutlet weak var closeButton: UIButton!{
        didSet {
            let closeButtonImage = UIImage(named: "close")?.renderAlwaysWithTemplateMode()
            closeButton.setImage(closeButtonImage, for: .normal)
            closeButton.tintColor = .black
        }
    }
    @IBOutlet weak var exitPopUpTitleLabel: UILabel!
    @IBOutlet weak var exitPopUpDescriptionLabel: UILabel!
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var stayButton: UIButton!
    
    //MARK: - Variables
    private var exitPopUpViewModel: ExitPopUpViewModel
    private var currentNavigationController: UINavigationController
    
    weak var delegate: ExitPopUpDelegate?
    
    //MARK: - Init Method
    init(currentNavigationController: UINavigationController, partnerName: String, themeColor: UIColor) {
        self.currentNavigationController = currentNavigationController
        self.exitPopUpViewModel = ExitPopUpViewModel(partnerName: partnerName, themeColor: themeColor)
        super.init(nibName: "ExitPopUpViewController", bundle: Bundle.getFrameworkBundle())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Overriden Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.exitPopUpView.applyRoundedCorners(cornerRadius: 16, corners: [.topLeft, .topRight])
    }

    //MARK: - Actions
    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismissPopUpView()
    }
    
    @IBAction func exitButtonAction(_ sender: Any) {
        self.delegate?.exitConnectTransfer()
        self.dismissPopUpView()
        self.currentNavigationController.dismiss(animated: true)
    }
    
    @IBAction func stayButtonAction(_ sender: Any) {
        self.dismissPopUpView()
    }
    
    //MARK: - Private Methods
    private func setUpViews() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.setUpParentViewDimension()
        self.setUpExitPopUpView()
        self.setUpExitPopUpTitleLabel()
        self.setUpExitPopUpDescriptionLabel()
        self.setUpExitButton()
        self.setUpStayButton()
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
    
    private func setUpExitPopUpView() {
        self.exitPopUpView.backgroundColor = ExitPopUpViewControllerUtil.getExitPopUpBackgroundColor()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            UIView.animate(withDuration: 0.4) {
                self.exitPopUpParentView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            }
        }
    }
    
    private func dismissPopUpView() {
        
        if Thread.isMainThread {
            self.exitPopUpParentView.backgroundColor = UIColor.clear
            self.dismiss(animated: true)
            
        }else {
            
            DispatchQueue.main.async {
                self.dismissPopUpView()
            }
        }
    }
    
    private func setUpExitPopUpTitleLabel() {
        self.exitPopUpTitleLabel.text = ExitPopUpViewControllerUtil.getExitPopUpTitleText()
        self.exitPopUpTitleLabel.font = UIFont.systemFont(ofSize: 21.33, weight: .bold)
        self.exitPopUpTitleLabel.textColor = ExitPopUpViewControllerUtil.getExitPopUpTitleTextColor()
    }
    
    private func setUpExitPopUpDescriptionLabel() {
        self.exitPopUpDescriptionLabel.text = self.exitPopUpViewModel.getExitDescriptionText()
        self.exitPopUpDescriptionLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        self.exitPopUpDescriptionLabel.textColor = ExitPopUpViewControllerUtil.getExitPopUpDescriptionTextColor()
    }
    
    private func setUpExitButton() {
        self.exitButton.backgroundColor = self.exitPopUpViewModel.getThemeColor()
        self.exitButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        self.exitButton.setTitle(ExitPopUpViewControllerUtil.getExitButtonText(), for: .normal)
        self.exitButton.setTitleColor(self.exitPopUpViewModel.getExitButtonTextColor(), for: .normal)
    }
    
    private func setUpStayButton() {
        self.stayButton.backgroundColor = .white
        self.stayButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        self.stayButton.setTitle(ExitPopUpViewControllerUtil.getStayButtonText(), for: .normal)
        self.stayButton.setTitleColor(self.exitPopUpViewModel.getThemeColor(), for: .normal)
        self.stayButton.setBorder(borderRadius: 1.0, borderColor: self.exitPopUpViewModel.getThemeColor())
    }
}
