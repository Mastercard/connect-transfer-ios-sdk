# Connect Transfer iOS SDK

## Overview

The Connect Transfer iOS SDK allows you to embed MastercardOpenBanking Connect Transfer anywhere you want within your own mobile applications.

## Compatibility

The Connect Transfer iOS SDK supports iOS 14 or later.
Note that this Connect Transfer SDK is not suitable for Mastercard Open Banking Europe. 

## Install the Connect Transfer iOS SDK

Install the Connect Transfer iOS SDK using CocoaPods Support or by manually dragging ConnectTransfer.xcframework into your Xcode project.

### Swift Package Manager

To install the Connect Transfer iOS SDK Please perform the below steps.
Inside Xcode, go to Project Settings -> Project -> Package Dependencies and click the + to add a new Package.

Enter the Package URL
https://github.com/Mastercard/connect-transfer-ios-sdk

### CocoaPods

To install the Connect Transfer iOS SDK include the following in your Podfile.

```
use_frameworks!
pod 'MastercardOpenBankingConnectTransfer'
```

### Manual Install

Download the Connect Transfer iOS SDK from Github test link.
Open your project in Xcode and drag the ConnectTransfer.xcframework folder into your project.
In the build settings for the target folder, select the General tab.
Scroll down to the Frameworks, Libraries, and Embedded Content section, and select ConnectTransfer.xcframework.
Under the Embed column, select Embed & Sign from the menu drop-down list if it is not already selected.

### Integration

Add import ConnectTransfer to all your source files that make calls to the Connect Transfer iOS SDK:

```
import UIKit
import ConnectTransfer
```

- Generate a valid URL (see Generate Connect Transfer URL APIs Test Link).
- Create an instance of the ConnectTransferViewController class and assign ConnectTransferEventDelegate to ConnectTransferViewController. Use the Connect Transfer URL in the load function (see ConnectTransferUrl in the code example below).
- Create callback/delegate functions for onInitializeTransferDone, onTermsAndConditionsAccepted, onInitializeDepositSwitch, onTransferEnd, onUserEvent events. These callback functions will have a NSDictionary? parameter that contains data about the event. For more information see here test link.
- In the onLoad callback delegate method, present the ConnectTransferViewController using a UINavigationController with the ConnectTransferViewcontroller as its rootViewController.
Note: The ConnectTransferViewController automatically dismisses when the Connect flow is completed, cancelled early by the user, or when an error occurs.

### Example

The following is an example of the delegate functions and their usage.

```
class ViewController: UIViewController {
 
 @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var transferViewController: ConnectTransferViewController!
    var connectNavController: UINavigationController!
 
func launchConnectTransferAction(_ sender: Any) {
        if let connectTransferUrl = pdsURLInput.text {
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
```

## ConnectTransferWrapper Swift Sample App

This repository contains a sample application ConnectTransferWrapper written in Swift (requires Xcode 14 or greater) that demonstrates integration and use of Connect Transfer iOS SDK.


