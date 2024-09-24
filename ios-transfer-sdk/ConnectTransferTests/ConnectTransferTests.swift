//
//  ConnectTests.swift
//  ConnectTests
//
//  Copyright © 2024 MastercardOpenBanking. All rights reserved.
//

import XCTest
@testable import ConnectTransfer

import WebKit

class ConnectTransferTests: XCTestCase {
    
    
    
    var onLoadCalled = false
    var onDoneCalled = false
    var onErrorCalled = false
    var onCancelCalled = false
    var onRouteCalled = false
    var onUserCalled = false
    var message: NSDictionary! = nil
    
    
    var onInitializeTransferDoneCalled = false
    var onTermsAndConditionsAcceptedCalled = false
    var onInitializeDepositSwitchCalled = false
    var onTransferEndCalled = false
    var onUserEventCalled = false
    
    var onInitializeTransferDoneExp: XCTestExpectation? = nil
    var onTermsAndConditionsAcceptedExp: XCTestExpectation? = nil
    var onInitializeDepositSwitchExp: XCTestExpectation? = nil
    var onTransferEndExp: XCTestExpectation? = nil
    var onUserEventExp: XCTestExpectation? = nil
    
    var connectNavController: UINavigationController!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        resetState()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        resetState()
    }
    
    func resetState() {
      
        self.onInitializeTransferDoneCalled = false
        self.onTermsAndConditionsAcceptedCalled = false
        self.onInitializeDepositSwitchCalled = false
        self.onTransferEndCalled = false
        self.onUserEventCalled = false
        
        
        self.onInitializeTransferDoneExp = nil
        self.onTermsAndConditionsAcceptedExp = nil
        self.onInitializeDepositSwitchExp = nil
        self.onTransferEndExp = nil
        self.onUserEventExp = nil
    }
    
    //    func testToken() {
    //         let awesomeToken = ProcessInfo.processInfo.environment["FINICITY_APP_KEY_SAVED"]!
    //         print(awesomeToken)
    //         XCTAssertFalse(awesomeToken.isEmpty)
    //   }
    
    
    func testLoad() {
        let ctvc = ConnectTransferViewController(connectTransferURLString: "connectTransferUrl")
        ctvc.delegate = self
        XCTAssertEqual("connectTransferUrl", ctvc.transferViewModel.testConnectTransferURLString())
        XCTAssertNil(ctvc.presentedViewController)
    }
    
    
    func testUnload() {
        let ctvc = ConnectTransferViewController(connectTransferURLString: "connectTransferUrl")
        ctvc.delegate = self
        XCTAssertEqual("connectTransferUrl", ctvc.transferViewModel.testConnectTransferURLString())
        
        ctvc.exitConnectTransfer()
        XCTAssertNil(ctvc.presentedViewController)
    }
    
    func testLoadView() {
        let ctvc = ConnectTransferViewController(connectTransferURLString: "connectTransferUrl")
        ctvc.delegate = self
        self.connectNavController = UINavigationController(rootViewController: ctvc)
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        window.rootViewController =  self.connectNavController
        
        XCTAssertEqual("connectTransferUrl",  ctvc.transferViewModel.testConnectTransferURLString())
        
    }
    
    func testLoadRedirectView() {
        let ctvc = ConnectTransferViewController(connectTransferURLString: "connectTransferUrl")
        ctvc.delegate = self
        self.connectNavController = UINavigationController(rootViewController: ctvc)
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        window.rootViewController =  self.connectNavController
        
        ctvc.openRedirectVC()
        sleep(10)
        
        XCTAssertNotNil(ctvc.navigationController?.topViewController)
        XCTAssertTrue(((ctvc.navigationController?.topViewController?.isKind(of: ConnectTransferRedirectViewController.classForCoder())) != nil))
        XCTAssertEqual("connectTransferUrl",  ctvc.transferViewModel.testConnectTransferURLString())
        
        ctvc.delegate?.onTransferEnd(NSDictionary(object: "onTransferEnd",forKey: "onTransferEnd" as NSCopying))
    }
    
    
    func testLoadFailureView() {
        let renderOAuthWebViewExpectation = expectation(description: "RenderFailureView")
        
        class ConnectTransferViewControllerMock: ConnectTransferViewController {
            var renderOAuthWebViewExpectation: XCTestExpectation!
            var didCallRenderOAuthWebView = false
        }
        
        let ctvc = ConnectTransferViewControllerMock(connectTransferURLString: "connectTransferUrl")
        XCTAssertEqual(ctvc.didCallRenderOAuthWebView, false)
        ctvc.renderOAuthWebViewExpectation = renderOAuthWebViewExpectation
        
        ctvc.delegate = self
        self.connectNavController = UINavigationController(rootViewController: ctvc)
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        window.rootViewController =  self.connectNavController
        
        
        ctvc.testLoadConnectTransfer(shouldLoadConnectTransfer: true) { success in
            if(success){
                ctvc.didCallRenderOAuthWebView = true
                renderOAuthWebViewExpectation.fulfill()
            }
        }
        waitForExpectations(timeout: 1) { _ in
            XCTAssertEqual(ctvc.didCallRenderOAuthWebView, true)
        }
        
    }
    
    func testLoadFailOfFailureView() {
        let renderOAuthWebViewExpectation = expectation(description: "RenderFailureView")
        
        class ConnectTransferViewControllerMock: ConnectTransferViewController {
            var renderOAuthWebViewExpectation: XCTestExpectation!
            var didCallRenderOAuthWebView = false
        }
        
        let ctvc = ConnectTransferViewControllerMock(connectTransferURLString: "connectTransferUrl")
        XCTAssertEqual(ctvc.didCallRenderOAuthWebView, false)
        ctvc.renderOAuthWebViewExpectation = renderOAuthWebViewExpectation
        
        ctvc.delegate = self
        self.connectNavController = UINavigationController(rootViewController: ctvc)
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        window.rootViewController =  self.connectNavController
        
        ctvc.testLoadConnectTransfer(shouldLoadConnectTransfer: false) { success in
            if(success){
                ctvc.didCallRenderOAuthWebView = true
                renderOAuthWebViewExpectation.fulfill()
            }else{
                ctvc.didCallRenderOAuthWebView = false
                renderOAuthWebViewExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1) { _ in
            XCTAssertEqual(ctvc.didCallRenderOAuthWebView, false)
        }
        
    }

        func testMemoryLeak() {
            
            let ctvc = ConnectTransferViewController(connectTransferURLString: "connectTransferUrl")
            ctvc.delegate = self
            self.connectNavController = UINavigationController(rootViewController: ctvc)
            
            let window = UIWindow(frame: UIScreen.main.bounds)
            window.makeKeyAndVisible()
            window.rootViewController =  self.connectNavController
            
            
            self.onInitializeTransferDoneExp = expectation(description: "Loaded connect transfer")
            
            waitForExpectations(timeout: 3) { _ in
                XCTAssertTrue(self.onInitializeTransferDoneCalled)
                XCTAssertEqual("testConnectUrl", ctvc.transferViewModel.testConnectTransferURLString())
            }
    
            window.rootViewController = UINavigationController(rootViewController: UIViewController())
    
            addTeardownBlock { [weak ctvc] in
                XCTAssertNil(ctvc)
            }
        }
    
    
        func testCallbacks() {
            let ctvc = ConnectTransferViewController(connectTransferURLString: "connectTransferUrl")
            ctvc.delegate = self
            self.connectNavController = UINavigationController(rootViewController: ctvc)
            
            let window = UIWindow(frame: UIScreen.main.bounds)
            window.makeKeyAndVisible()
            window.rootViewController =  self.connectNavController
       
            XCTAssertTrue(self.onInitializeTransferDoneCalled)
    
            ctvc.nextButtonAction(Any.self)
            XCTAssertTrue(self.onTermsAndConditionsAcceptedCalled)
           
            ctvc.testLoadConnectTransfer(shouldLoadConnectTransfer: true) { success in
                XCTAssertTrue(self.onInitializeDepositSwitchCalled)
            }
           
        }
    
    func testJailBreakCheck() {
        let cvc = ConnectTransferViewController(connectTransferURLString: "connectTransferUrl")
        XCTAssertFalse(cvc.hasBeenJailBroken())
    }
    
}

extension ConnectTransferTests: ConnectTransferEventDelegate {
    
    func onInitializeTransferDone(_ data: NSDictionary?) {
        self.onInitializeTransferDoneCalled = true
        self.message = data
        self.onInitializeTransferDoneExp?.fulfill()
    }
    
    func onTermsAndConditionsAccepted(_ data: NSDictionary?) {
        self.onTermsAndConditionsAcceptedCalled = true
        self.message = data
        self.onTermsAndConditionsAcceptedExp?.fulfill()
    }
    
    func onInitializeDepositSwitch(_ data: NSDictionary?) {
        self.onInitializeDepositSwitchCalled = true
        self.message = data
        self.onInitializeDepositSwitchExp?.fulfill()
    }
    
    func onTransferEnd(_ data: NSDictionary?) {
        self.onTransferEndCalled = true
        self.message = data
        self.onTransferEndExp?.fulfill()
    }
    
    func onUserEvent(_ data: NSDictionary?) {
        self.onUserEventCalled = true
        self.message = data
        self.onUserEventExp?.fulfill()
    }
}

final class MockNavigationAction: WKNavigationAction {
    var mockedRequest: URLRequest!
    override var request: URLRequest {
        return mockedRequest
    }
    
    
}
