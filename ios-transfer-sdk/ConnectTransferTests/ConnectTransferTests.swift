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
    var onLoadExp: XCTestExpectation? = nil
    var onErrorExp: XCTestExpectation? = nil
    var onDoneExp: XCTestExpectation? = nil
    var onRouteExp: XCTestExpectation? = nil
    var onUserExp: XCTestExpectation? = nil
    var onCancelExp: XCTestExpectation? = nil
    
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
        let cvc = ConnectTransferViewController(connectTransferURLString: "connectTransferUrl")
        cvc.delegate = self
        XCTAssertEqual("connectTransferUrl", cvc.transferViewModel.testConnectTransferURLString())
       // cvc.unloadChildWebView()
      //  cvc.postWindowClosedMessage()
        XCTAssertNil(cvc.presentedViewController)
    }
    
    
//    func testUnload() {
//        let cvc = ConnectViewController()
//        cvc.load("testConnectUrl")
//        cvc.delegate = self
//        XCTAssertEqual("testConnectUrl", cvc.connectUrl)
//        cvc.unloadChildWebView()
//        if(cvc.webView != nil){
//            cvc.webViewDidClose(cvc.webView)
//        }
//        // cvc.postWindowClosedMessage()
//        XCTAssertNil(cvc.presentedViewController)
//    }
//    
//    func testLoadWebView() {
//        self.onLoadExp = expectation(description: "Loaded callback")
//        let cvc = ConnectViewController()
//        cvc.load("testConnectUrl")
//        cvc.delegate = self
//        waitForExpectations(timeout: 3) { _ in
//            XCTAssertTrue(self.onLoadCalled)
//            XCTAssertEqual("testConnectUrl", cvc.connectUrl)
//        }
//    }
//    
//    func testLoadDeeplink() {
//        let cvc = ConnectViewController()
//        cvc.load("testConnectUrl",redirectUrl: "partnerapp://")
//        cvc.delegate = self
//        XCTAssertEqual("testConnectUrl", cvc.connectUrl)
//    }
//    func testLoadUniversallink() {
//        let cvc = ConnectViewController()
//        cvc.load("testConnectUrl",redirectUrl: "https://acmelending.net")
//        cvc.delegate = self
//        XCTAssertEqual("testConnectUrl", cvc.connectUrl)
//    }
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
//    func testMemoryLeak() {
//        self.onLoadExp = expectation(description: "Loaded callback")
//        let cvc = ConnectViewController()
//        cvc.load("testConnectUrl")
//        cvc.delegate = self
//        waitForExpectations(timeout: 3) { _ in
//            XCTAssertTrue(self.onLoadCalled)
//            XCTAssertEqual("testConnectUrl", cvc.connectUrl)
//        }
//        
//        cvc.close()
//        cvc.unload()
//        
//        addTeardownBlock { [weak cvc] in
//            XCTAssertNil(cvc)
//        }
//    }
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
        
    }
    
    func onTermsAndConditionsAccepted(_ data: NSDictionary?) {
        
    }
    
    func onInitializeDepositSwitch(_ data: NSDictionary?) {
        
    }
    
    func onTransferEnd(_ data: NSDictionary?) {
        
    }
    
    func onUserEvent(_ data: NSDictionary?) {
        
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
