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
    
    var onInitializeTransferDone: XCTestExpectation? = nil
    var onTermsAndConditionsAccepted: XCTestExpectation? = nil
    var onInitializeDepositSwitch: XCTestExpectation? = nil
    var onTransferEnd: XCTestExpectation? = nil
    var onUserEvent: XCTestExpectation? = nil
    
    
    
    var onLoadExp: XCTestExpectation? = nil
    var onErrorExp: XCTestExpectation? = nil
    var onDoneExp: XCTestExpectation? = nil
    var onRouteExp: XCTestExpectation? = nil
    var onUserExp: XCTestExpectation? = nil
    var onCancelExp: XCTestExpectation? = nil
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
        self.onLoadCalled = false
        self.onDoneCalled = false
        self.onErrorCalled = false
        self.onCancelCalled = false
        self.onRouteCalled = false
        self.onUserCalled = false
        self.message = nil
        self.onLoadExp = nil
        self.onErrorExp = nil
        self.onDoneExp = nil
        self.onRouteExp = nil
        self.onUserExp = nil
        self.onCancelExp = nil
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
    
    
    //
    //
    //    func testLoadWebViewDeeplink() {
    //        self.onLoadExp = expectation(description: "Loaded callback")
    //        let cvc = ConnectViewController()
    //        cvc.load("testConnectUrl",redirectUrl: "partnerapp://")
    //        cvc.delegate = self
    //
    //        let expectation = XCTestExpectation(description: "Completed Ping Connect")
    //        DispatchQueue.main.async {
    //            cvc.pingConnect()
    //            expectation.fulfill()
    //        }
    //
    //        wait(for: [expectation], timeout: 10.0)
    //
    //        waitForExpectations(timeout: 3) { _ in
    //            XCTAssertTrue(self.onLoadCalled)
    //            XCTAssertEqual("testConnectUrl", cvc.connectUrl)
    //        }
    //    }
    //
    //    func testLoadWebChildWebView() {
    //
    //        self.onLoadExp = expectation(description: "Loaded callback")
    //        let cvc = ConnectViewController()
    //        cvc.load("testConnectUrl",redirectUrl: "partnerapp://")
    //        cvc.delegate = self
    //
    //        let expectation = XCTestExpectation(description: "Completed Ping Connect")
    //        DispatchQueue.main.async {
    //            cvc.loadChildWebView(url: URL(string: "testChildUrl")!)
    //            expectation.fulfill()
    //        }
    //
    //        wait(for: [expectation], timeout: 10.0)
    //
    //        waitForExpectations(timeout: 3) { _ in
    //            XCTAssertTrue(self.onLoadCalled)
    //            XCTAssertEqual("testConnectUrl", cvc.connectUrl)
    //        }
    //    }
    //
        func testMemoryLeak() {
            
            let ctvc = ConnectTransferViewController(connectTransferURLString: "connectTransferUrl")
            ctvc.delegate = self
            self.connectNavController = UINavigationController(rootViewController: ctvc)
            
            let window = UIWindow(frame: UIScreen.main.bounds)
            window.makeKeyAndVisible()
            window.rootViewController =  self.connectNavController
            
            
            self.onLoadExp = expectation(description: "Loaded callback")
            let cvc = ConnectViewController()
            cvc.load("testConnectUrl")
            cvc.delegate = self
            waitForExpectations(timeout: 3) { _ in
                XCTAssertTrue(self.onLoadCalled)
                XCTAssertEqual("testConnectUrl", cvc.connectUrl)
            }
    
            cvc.close()
            cvc.unload()
    
            addTeardownBlock { [weak cvc] in
                XCTAssertNil(cvc)
            }
        }
    //
    //
    //    func testCallbacks() {
    //        let cvc = ConnectViewController()
    //        cvc.load("testConnectUrl")
    //        cvc.delegate = self
    //
    //        cvc.handleLoadingComplete()
    //        XCTAssertTrue(self.onLoadCalled)
    //
    //        self.message = ["key": "value"]
    //        cvc.handleConnectCancel(nil)
    //        XCTAssertTrue(self.onCancelCalled)
    //        XCTAssertEqual(nil, self.message)
    //
    //        self.message = ["key": "value"]
    //        cvc.handleConnectComplete(nil)
    //        XCTAssertTrue(self.onDoneCalled)
    //        XCTAssertEqual(nil, self.message)
    //
    //        self.message = ["key": "value"]
    //        cvc.handleConnectError(nil)
    //        XCTAssertTrue(self.onErrorCalled)
    //        XCTAssertEqual(nil, self.message)
    //
    //        self.message = ["key": "value"]
    //        cvc.handleConnectUser(nil)
    //        XCTAssertTrue(self.onUserCalled)
    //        XCTAssertEqual(nil, self.message)
    //
    //        self.message = ["key": "value"]
    //        cvc.handleConnectRoute(nil)
    //        XCTAssertTrue(self.onRouteCalled)
    //        XCTAssertEqual(nil, self.message)
    //    }
    
    func testJailBreakCheck() {
        let cvc = ConnectTransferViewController(connectTransferURLString: "connectTransferUrl")
        XCTAssertFalse(cvc.hasBeenJailBroken())
    }
    
}

extension ConnectTransferTests: ConnectTransferEventDelegate {
    
    func onInitializeTransferDone(_ data: NSDictionary?) {
        self.onInitializeTransferDone?.fulfill()
    }
    
    func onTermsAndConditionsAccepted(_ data: NSDictionary?) {
        self.onTermsAndConditionsAccepted?.fulfill()
    }
    
    func onInitializeDepositSwitch(_ data: NSDictionary?) {
        self.onInitializeDepositSwitch?.fulfill()
    }
    
    func onTransferEnd(_ data: NSDictionary?) {
        self.onTransferEnd?.fulfill()
    }
    
    func onUserEvent(_ data: NSDictionary?) {
        self.onUserEvent?.fulfill()
    }
    
    
    
    
    
    
    func onCancel(_ data: NSDictionary?) {
        self.onCancelCalled = true
        self.message = data
        self.onCancelExp?.fulfill()
    }
    func onDone(_ data: NSDictionary?) {
        self.onDoneCalled = true
        self.message = data
        self.onDoneExp?.fulfill()
    }
    func onError(_ data: NSDictionary?) {
        self.onErrorCalled = true
        self.message = data
        self.onErrorExp?.fulfill()
    }
    func onLoad() {
        self.onLoadCalled = true
        self.onLoadExp?.fulfill()
    }
    func onRoute(_ data: NSDictionary?) {
        self.onRouteCalled = true
        self.message = data
        self.onRouteExp?.fulfill()
    }
    func onUser(_ data: NSDictionary?) {
        self.onUserCalled = true
        self.message = data
        self.onUserExp?.fulfill()
    }
}

final class MockNavigationAction: WKNavigationAction {
    var mockedRequest: URLRequest!
    override var request: URLRequest {
        return mockedRequest
    }
    
    
}
