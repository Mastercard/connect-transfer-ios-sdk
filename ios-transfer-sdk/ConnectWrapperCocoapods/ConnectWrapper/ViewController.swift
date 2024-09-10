//
//  ViewController.swift
//  ConnectWrapper
//
//  Copyright © 2022 MastercardOpenBanking. All rights reserved.
//

import UIKit
import Connect
import ConnectTransfer

class ViewController: UIViewController {
   
    
    
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var urlInput: UITextField!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var uiRedirectUrlTextBoxHeight: NSLayoutConstraint!
    
    @IBOutlet weak var uiConnectSDKRadioBtnWrapperViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var redirectUrlInput: UITextField!
    
    @IBOutlet weak var uiViewConnectSDKRadioBtnWrap: UIView!
        var connectViewController: ConnectViewController!
        var connectNavController: UINavigationController!
    
    var transferViewController: ConnectTransferViewController!
    
    let gradientLayer = CAGradientLayer()
    
    @IBOutlet weak var btnSTG: UIButton!
    @IBOutlet weak var btnProd: UIButton!
    @IBOutlet weak var btnRedirectUrl: UIButton!
    
    @IBOutlet weak var btnLaunchConnect: UIButton!
    
    @IBOutlet weak var btnLaunchAtomic: UIButton!
    
    let radioControllerSelectAtomicOrConnectView: RadioButtonController = RadioButtonController()
    
    let radioControllerConnectSDK: RadioButtonController = RadioButtonController()
    
    // Select Connect SDK enviroment
    @IBAction func btnSTGAction(_ sender: UIButton) {
        uiRedirectUrlTextBoxHeight.constant = 0
        radioControllerConnectSDK.buttonArrayUpdated(buttonSelected: sender)
    }
    
    @IBAction func btnProdAction(_ sender: UIButton) {
        uiRedirectUrlTextBoxHeight.constant = 0
        radioControllerConnectSDK.buttonArrayUpdated(buttonSelected: sender)
    }
    
    @IBAction func btnRedirectUrlAction(_ sender: UIButton) {
        radioControllerConnectSDK.buttonArrayUpdated(buttonSelected: sender)
        uiRedirectUrlTextBoxHeight.constant = 56
    }
    
    
    // Select View to be Launched
    @IBAction func btnLauchConnectAction(_ sender: UIButton) {
        uiViewConnectSDKRadioBtnWrap.isHidden = false
        radioControllerSelectAtomicOrConnectView.buttonArrayUpdated(buttonSelected: sender)
    }
    
    @IBAction func btnLaunchAtomicAction(_ sender: UIButton) {
        uiViewConnectSDKRadioBtnWrap.isHidden = true
        radioControllerSelectAtomicOrConnectView.buttonArrayUpdated(buttonSelected: sender)
    }
    
    
    override func viewDidLoad() {
        uiRedirectUrlTextBoxHeight.constant = 0
        radioControllerConnectSDK.buttonsArray = [btnSTG,btnProd,btnRedirectUrl]
        radioControllerConnectSDK.defaultButton = btnProd
        
        uiViewConnectSDKRadioBtnWrap.isHidden = false
        radioControllerSelectAtomicOrConnectView.buttonsArray = [btnLaunchConnect,btnLaunchAtomic]
        radioControllerSelectAtomicOrConnectView.defaultButton = btnLaunchConnect
                
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Query Connect.xcframework for SDK version.
        //print("Connect.xcframework SDK version: \(sdkVersion())")
        
        self.navigationController?.navigationBar.isHidden = true
        setupViews()
        
        // Add tap gesture recognizer to dismiss keyboard when tapped outside of textfield.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(screenTapped))
        view.addGestureRecognizer(tapGesture)
        
        //        urlInput.accessibilityIdentifier = AccessiblityIdentifer.urlTextField.rawValue
        //        connectButton.accessibilityIdentifier = AccessiblityIdentifer.connectButton.rawValue
        
        urlInput.becomeFirstResponder()
    }
    
    // For iPad rotation need to adjust gradient frame size
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.frame
    }
    
    // If screen tapped then end editing in textField
    @objc func screenTapped(gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // On startup initialize sub-views that cannot be initialized in storyboard.
    private func setupViews() {
        setGradientBackgroundLayer()
        
        activityIndicator.style = .large
        activityIndicator.color = .white
        
        infoView.layer.cornerRadius = 8
        connectButton.layer.cornerRadius = 24
        connectButton.isEnabled = false
        connectButton.setTitleColor(UIColor(red: 254.0/255.0, green: 254.0/255.0, blue: 254.0/255.0, alpha: 0.32), for: .disabled)
        connectButton.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
    }
    
    // Added gradient background layer to view hierarchy
    private func setGradientBackgroundLayer() {
        
        gradientLayer.colors = [
            UIColor(red: 0.518, green: 0.714, blue: 0.427, alpha: 1).cgColor,
            UIColor(red: 0.004, green: 0.537, blue: 0.616, alpha: 1).cgColor,
            UIColor(red: 0.008, green: 0.22, blue: 0.447, alpha: 1).cgColor
        ]
        gradientLayer.locations = [0, 0.4, 1]
        
        // Diagonal Gradient
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = view.frame
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    @IBAction func startButtonClicked(_ sender: UIButton) {
        view.endEditing(true)
        activityIndicator.startAnimating()
        
        if(btnLaunchAtomic.isSelected){
            // Load Atomic SDK
            launchConnectTransferAction()
        }
        else{
            //Load Connect SDK
            self.openWebKitConnectView()
        }
        
        
       
    }
    
    func openWebKitConnectView() {
        
      
        
        if let connectUrl = urlInput.text {
            print("creating & loading connectViewController")
            self.connectViewController = ConnectViewController()
            self.connectViewController.delegate = self
            
            if(btnSTG.isSelected){
                self.connectViewController.load(connectUrl,redirectUrl: "https://acme.finicitystg.com")
            }
            else if(btnProd.isSelected){
                self.connectViewController.load(connectUrl,redirectUrl: "https://acmelending.net")
            }
            else if(btnRedirectUrl.isSelected){
                if let redirectUrl = redirectUrlInput.text {
                    if(redirectUrl == ""){
                        self.connectViewController.load(connectUrl)
                    }else{
                        self.connectViewController.load(connectUrl,redirectUrl:redirectUrl)
                    }
                }
               
            }

        } else {
            print("no connect url provided.")
            activityIndicator.stopAnimating()
        }
    }
    
     func launchConnectTransferAction() {
        if let connectTransferUrl = urlInput.text {
            self.transferViewController = ConnectTransferViewController(connectTransferURLString: connectTransferUrl)
            self.transferViewController.delegate = self
            self.connectNavController = UINavigationController(rootViewController: self.transferViewController)
            if(UIDevice.current.userInterfaceIdiom == .phone){
                self.connectNavController.modalPresentationStyle = .fullScreen
            }else{
                self.connectNavController.modalPresentationStyle = .automatic
            }
            self.present(self.connectNavController, animated: true)
        }
    }
    
    
    func displayData(_ data: NSDictionary?) {
        print(data?.debugDescription ?? "no data in callback")
    }
    
}

extension ViewController: ConnectEventDelegate {
    func onCancel(_ data: NSDictionary?) {
        print("onCancel:")
        displayData(data)
        self.activityIndicator.stopAnimating()
        // Needed to trigger deallocation of ConnectViewController
        self.connectViewController = nil
        self.connectNavController = nil
    }
    
    func onDone(_ data: NSDictionary?) {
        print("onDone:")
        displayData(data)
        self.activityIndicator.stopAnimating()
        // Needed to trigger deallocation of ConnectViewController
        self.connectViewController = nil
        self.connectNavController = nil
    }
    
    func onError(_ data: NSDictionary?) {
        print("onError:")
        displayData(data)
        self.activityIndicator.stopAnimating()
        // Needed to trigger deallocation of ConnectViewController
        self.connectViewController = nil
        self.connectNavController = nil
    }
    
    func onLoad() {
        print("onLoad:")
        self.connectNavController = UINavigationController(rootViewController: self.connectViewController)
        self.connectNavController.modalPresentationStyle = .automatic
        self.connectNavController.isModalInPresentation = true
        self.connectNavController.presentationController?.delegate = self
        self.present(self.connectNavController, animated: true)
    }
    
    func onRoute(_ data: NSDictionary?) {
        print("onRoute:")
        displayData(data)
    }
    
    func onUser(_ data: NSDictionary?) {
        print("onUser:")
        displayData(data)
    }
}

extension ViewController: ConnectTransferEventDelegate {
    
    func onInitializeTransferDone(_ data: NSDictionary?) {
        print(data as Any)
    }
    
    func onTermsAndConditionsAccepted(_ data: NSDictionary?) {
        print(data as Any)
    }
    
    func onInitializeDepositSwitch(_ data: NSDictionary?) {
        print(data as Any)
    }
    
    func onTransferEnd(_ data: NSDictionary?) {
        print(data as Any)
        if Thread.isMainThread {
            
            let alert = UIAlertController(title: "Error", message: data!["reason"] as? String ?? "" , preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
            self.present(alert, animated: true)
            
        }else {
            DispatchQueue.main.async {
                self.onTransferEnd(data)
            }
        }
    }
    
    func onUserEvent(_ data: NSDictionary?) {
        print(data as Any)
    }
    
}



extension ViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        print("connectViewController dismissed by gesture")
        self.activityIndicator.stopAnimating()
    }
}

// If textfield is not empty enable connect button, otherwise disable connect button
extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        let newLength = text.count + string.count - range.length
        let isEnabled = newLength > 0
        connectButton.isEnabled = isEnabled
        // Adjust opacity based on button enabled state
        if isEnabled {
            connectButton.backgroundColor = UIColor(red: 254.0 / 255.0, green: 254.0 / 255.0, blue: 254.0 / 255.0, alpha: 0.24)
        } else {
            connectButton.backgroundColor = UIColor(red: 254.0 / 255.0, green: 254.0 / 255.0, blue: 254.0 / 255.0, alpha: 0.16)
        }
        return true
    }
}
