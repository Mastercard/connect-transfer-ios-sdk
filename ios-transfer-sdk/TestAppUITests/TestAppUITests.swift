//
//  TestAppUITests.swift
//  TestAppUITests
//
//  Created by Jimmie Wright on 12/15/20.
//  Copyright © 2024 MastercardOpenBanking. All rights reserved.
//

import XCTest
//import MastercardOpenBankingConnect

var dynamicGeneratedUrl: String? = nil
let badExpiredUrl = "https://connect.finicity.com?consumerId=dbceec20d8b97174e6aed204856f5a55&customerId=1016927519&partnerId=2445582695152&redirectUri=http%3A%2F%2Flocalhost%3A3001%2Fcustomers%2FredirectHandler&signature=abb1762e5c640f02823c56332daede3fe2f2143f4f5b8be6ec178ac72d7dbc5a&timestamp=1607806595887&ttl=1607813795887"

class TestAppUITests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        //    First time setup called try and dynamically generate a Connect URL using linked in static library Connect
        if dynamicGeneratedUrl == nil {
            let onGenerateExp = expectation(description: "generate url")
            MastercardOpenBankingConnect.generateUrlLink { success, urlLink in
                if success, let url = urlLink {
                    dynamicGeneratedUrl = url
                }
                onGenerateExp.fulfill()
            }
            
                 
            waitForExpectations(timeout: 200) { _ in
                XCTAssertNotNil(dynamicGeneratedUrl)
            }
        }
        
        XCTAssertNotNil(dynamicGeneratedUrl)
    }
    
    func testToken() {
        let awesomeToken = ProcessInfo.processInfo.environment["FINICITY_APP_KEY_SAVED"]!
        print(awesomeToken)
        //  XCTAssertFalse(awesomeToken.isEmpty, awesomeToken)
    }
    
    
    
    
    func test01BadUrl() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        // Steps:
        // 1. Fill in textfield with bad/expired URL
        // 2. Tap Connect Button to launch WKWebView
        // 3. Assert Exit button exists
        // 4. Tap Exit button
        
        let uiTextField: XCUIElement = app.textFields[AccessiblityIdentifer.UrlTextField.rawValue]//.typeText(badExpiredUrl)
        uiTextField.typeText(badExpiredUrl)
        app.buttons[AccessiblityIdentifer.ConnectButton.rawValue].tap()
        // Wait 15 seconds for WebView with Exit button
        XCTAssert(app.webViews.webViews.webViews.buttons["EXIT"].waitForExistence(timeout: 15))
        app.webViews.webViews.webViews.buttons["EXIT"].tap()
        
        sleep(2)
    }
    
    func test02GoodUrlCancel() throws {
        
        XCTAssertNotNil(dynamicGeneratedUrl)
        
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        // Steps:
        // 1. Fill in textfield with good URL
        // 2. Tap Connect Button to launch WKWebView
        // 3. Assert Exit button exists
        // 4. Tap Exit button
        // 5. Assert Yes button exists
        // 6. Tap Yes button
        
        let uiTextField: XCUIElement = app.textFields[AccessiblityIdentifer.UrlTextField.rawValue]//.typeText(badExpiredUrl)
        uiTextField.typeText(dynamicGeneratedUrl!)
        app.buttons[AccessiblityIdentifer.ConnectButton.rawValue].tap()
        
        // Wait 5 seconds for WebView with Exit button
        let webViewsQuery = app.webViews.webViews.webViews
        //        XCTAssert(webViewsQuery.buttons["Skip to main content"].waitForExistence(timeout: 15))
        //        webViewsQuery.otherElements["Exit link, navigation"].tap()
        // Wait 5 seconds for WebView with Yes button
        XCTAssert(webViewsQuery.buttons["Exit"].waitForExistence(timeout: 15))
        webViewsQuery.buttons["Exit"].tap()
        
        sleep(2)
    }
    
    func test03AddBankAccount() throws {
        
        XCTAssertNotNil(dynamicGeneratedUrl)
        
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        let uiTextField: XCUIElement = app.textFields[AccessiblityIdentifer.UrlTextField.rawValue]//.typeText(badExpiredUrl)
        uiTextField.typeText(dynamicGeneratedUrl!)
        app.buttons[AccessiblityIdentifer.ConnectButton.rawValue].tap()
        
        let webViewsQuery = app.webViews.webViews.webViews
        XCTAssert(webViewsQuery.buttons["Next"].waitForExistence(timeout: 15))
        webViewsQuery.buttons["Next"].tap()
        XCTAssert(webViewsQuery.textFields["Search for your bank"].waitForExistence(timeout: 10))
        webViewsQuery.textFields["Search for your bank"].tap()
        webViewsQuery.textFields["Search for your bank"].typeText("finbank")
        sleep(5)
        XCTAssert(webViewsQuery.otherElements.staticTexts["FinBank"].waitForExistence(timeout: 15))
        webViewsQuery.otherElements.staticTexts["FinBank"].tap()
        
        sleep(2)
        
        XCTAssert(webViewsQuery.buttons["Next"].waitForExistence(timeout: 15))
        webViewsQuery.buttons["Next"].tap()
        XCTAssert(webViewsQuery.staticTexts["Banking Userid"].waitForExistence(timeout: 15))
        XCTAssert(webViewsQuery.staticTexts["Banking Password"].waitForExistence(timeout: 15))
        webViewsQuery.textFields["Banking Userid"].tap()
        webViewsQuery.textFields["Banking Userid"].typeText("demo")
        webViewsQuery.secureTextFields["Banking Password"].tap()
        webViewsQuery.secureTextFields["Banking Password"].typeText("go")
        sleep(2)
        app.keyboards.buttons["return"].tap()
//        sleep(2)
//        webViewsQuery.buttons["Submit"].tap()

        sleep(5)
        
        app.switches.element(boundBy: 1).tap()
        
        webViewsQuery.staticTexts["Line of Credit"].swipeUp()
        XCTAssert(webViewsQuery.buttons["Save"].waitForExistence(timeout: 5))
        webViewsQuery.buttons["Save"].tap()
        XCTAssert(webViewsQuery.buttons["Submit"].waitForExistence(timeout: 5))
        webViewsQuery.buttons["Submit"].tap()
        
        sleep(2)
    }
    
    
    
    
    
    func test05SafariViewController() throws {
        
        XCTAssertNotNil(dynamicGeneratedUrl)
        
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        app.textFields[AccessiblityIdentifer.UrlTextField.rawValue].typeText(dynamicGeneratedUrl!)
        app.buttons[AccessiblityIdentifer.ConnectButton.rawValue].tap()
        
        let webViewsQuery = app.webViews.webViews.webViews
        
        
        XCTAssert(webViewsQuery.links["Privacy Notice"].waitForExistence(timeout: 20))
        webViewsQuery.links["Privacy Notice"].tap()
        sleep(5)
        
//        let doneButton = app.buttons["Done"]
//        XCTAssert(doneButton.waitForExistence(timeout: 20))
//        doneButton.tap()
    }
    
    
    
    func test06AddOAuthBankAccount() throws {
        
        XCTAssertNotNil(dynamicGeneratedUrl)
        
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        let uiTextField: XCUIElement = app.textFields[AccessiblityIdentifer.UrlTextField.rawValue]//.typeText(badExpiredUrl)
        uiTextField.typeText(dynamicGeneratedUrl!)
        app.buttons[AccessiblityIdentifer.ConnectButton.rawValue].tap()
        
        let webViewsQuery = app.webViews.webViews.webViews
        sleep(1)
        XCTAssert(webViewsQuery.buttons["Next"].waitForExistence(timeout: 15))
        webViewsQuery.buttons["Next"].tap()
        XCTAssert(webViewsQuery.textFields["Search for your bank"].waitForExistence(timeout: 10))
        webViewsQuery.textFields["Search for your bank"].tap()
        webViewsQuery.textFields["Search for your bank"].typeText("finbank Oauth")
        sleep(1)
        XCTAssert(webViewsQuery.staticTexts["Finbank OAuth"].waitForExistence(timeout: 15))
        webViewsQuery.staticTexts["Finbank OAuth"].tap()
        
        sleep(1)
        
        XCTAssert(webViewsQuery.buttons["Next "].waitForExistence(timeout: 15))
        webViewsQuery.buttons["Next "].tap()
        sleep(5)
        XCTAssert(app.staticTexts["USERNAME"].waitForExistence(timeout: 15))
        XCTAssert(app.staticTexts["PASSWORD"].waitForExistence(timeout: 15))
        sleep(5)
//        app.staticTexts["USERNAME"].tap()
//        app.textFields["USERNAME"].typeText("profile_03")
//        app.staticTexts["PASSWORD"].tap()
//        app.secureTextFields["PASSWORD"].typeText("profile_03")
//        app.buttons["NEXT"].tap()
//        sleep(5)
//        
//        app.buttons["Allow"].tap()
        
        let doneButton = app.buttons["Done"]
        XCTAssert(doneButton.waitForExistence(timeout: 20))
        doneButton.tap()
        
        sleep(2)
    }
    
    
}
