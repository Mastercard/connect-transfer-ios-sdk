//
//  ViewController.swift
//  TestApp
//
//  Created by Jimmie Wright on 12/11/20.
//  Copyright © 2024 MastercardOpenBanking. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var urlInput: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var pdsURLInput: UITextField!
    @IBOutlet weak var launchConnectTransferButton: UIButton!
    
    var transferViewController: ConnectTransferViewController!
    var connectNavController: UINavigationController!
    let gradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.isHidden = true
        setupViews()
        
        // Add tap gesture recognizer to dismiss keyboard when tapped outside of textfield.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(screenTapped))
        view.addGestureRecognizer(tapGesture)
        
        urlInput.accessibilityIdentifier = AccessiblityIdentifer.UrlTextField.rawValue
        
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
        
        launchConnectTransferButton.layer.cornerRadius = 24
        launchConnectTransferButton.isEnabled = false
        launchConnectTransferButton.setTitleColor(UIColor(red: 254.0/255.0, green: 254.0/255.0, blue: 254.0/255.0, alpha: 0.32), for: .disabled)
        launchConnectTransferButton.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
    }
    
    // Added gradient background layer to view hierarchy
    private func setGradientBackgroundLayer() {
        
        gradientLayer.colors = [
            UIColor(red: 0.518, green: 0.714, blue: 0.427, alpha: 1).cgColor,
            UIColor(red: 0.004, green: 0.537, blue: 0.616, alpha: 1).cgColor,
            UIColor(red: 0.008, green: 0.22,  blue: 0.447, alpha: 1).cgColor
        ]
        gradientLayer.locations = [0, 0.4, 1]
        
        // Diagonal Gradient
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = view.frame
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
    @IBAction func launchConnectTransferAction(_ sender: Any) {
        activityIndicator.startAnimating()
        if let connectTransferUrl = pdsURLInput.text {
            self.transferViewController = ConnectTransferViewController()
            self.transferViewController.delegate = self
            self.transferViewController.loadConnectTransfer(with: connectTransferUrl)
        }
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
        
        if textField == self.urlInput {
            launchConnectTransferButton.isEnabled = isEnabled
            // Adjust opacity based on button enabled state
            if isEnabled {
                launchConnectTransferButton.backgroundColor = UIColor(red: 254.0 / 255.0, green: 254.0 / 255.0, blue: 254.0 / 255.0, alpha: 0.24)
            } else {
                launchConnectTransferButton.backgroundColor = UIColor(red: 254.0 / 255.0, green: 254.0 / 255.0, blue: 254.0 / 255.0, alpha: 0.16)
            }
            return true
        }

        return true
    }
}

extension ViewController: ConnectTransferEventDelegate {
    
    func onInitializeTransferDone(_ data: NSDictionary?) {
        print(data as Any)
        if Thread.isMainThread {
            self.activityIndicator.stopAnimating()
            self.connectNavController = UINavigationController(rootViewController: self.transferViewController)
            if(UIDevice.current.userInterfaceIdiom == .phone){
                self.connectNavController.modalPresentationStyle = .fullScreen
            }else{
                self.connectNavController.modalPresentationStyle = .fullScreen
            }
            self.present(self.connectNavController, animated: true)
        }else {
            DispatchQueue.main.async {
                self.onInitializeTransferDone(data)
            }
        }
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
            self.activityIndicator.stopAnimating()
            
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
