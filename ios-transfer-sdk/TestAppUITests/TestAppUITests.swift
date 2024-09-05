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
let badExpiredUrl = "https://connect2.finicitystg.com/transfer?customerId=7001515842&origin=url&partnerId=2445582169622&signature=c89647351a1bb2b93b3625c52b6023a8e809d0472e4af6bf015bc95f65094965&timestamp=1725346318530&ttl=1725432718530&type=transferDepositSwitch"

class TestAppUITests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // First time setup called try and dynamically generate a Connect PDS URL using linked in static library Connect
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
    
    //MARK: - Launching Screen TestCases
    func test01BadUrl() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        // Steps:
        // 1. Fill in textfield with bad/expired URL
        // 2. Tap Connect Transfer Button to launch Connect Transfer
        // 3. Wait for validation of the URL
        // 4. Alert will come for bad url
        // 5. Assert Ok button exists
        // 6. Tap Ok button
        
        let uiTextField: XCUIElement = app.textFields[AccessiblityIdentifer.UrlTextField.rawValue]
        uiTextField.typeText(badExpiredUrl)
        app.buttons[AccessiblityIdentifer.ConnectButton.rawValue].tap()
        
        // Wait 15 seconds for WebView with Exit button
        XCTAssert(app.buttons["Exit"].waitForExistence(timeout: 15))
        app.buttons["Exit"].tap()
        
        sleep(2)
    }
    
    func test02LaunchConnectTransferWithGoodURL() throws {
        XCTAssertNotNil(dynamicGeneratedUrl)
        
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        // Steps:
        // 1. Fill in textfield with Good URL (Dynamic Generated URL)
        // 2. Tap Connect Transfer Button to launch Connect Transfer
        // 3. Wait for validation of the URL
        // 4. Connect Transfer Screen will appear
        // 5. Check the same by checking if next button exist
        
        let uiTextField: XCUIElement = app.textFields[AccessiblityIdentifer.UrlTextField.rawValue]
        uiTextField.typeText(dynamicGeneratedUrl!)
        app.buttons[AccessiblityIdentifer.ConnectButton.rawValue].tap()
        
        let nextButton = app.buttons["Next"]
        XCTAssert(nextButton.waitForExistence(timeout: 15))
        
        sleep(2)
    }
    
    //MARK: - Landing Screen TestCases
    func test03CloseLandingScreen() throws {
        
        XCTAssertNotNil(dynamicGeneratedUrl)
        
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        // Steps:
        // 1. Fill in textfield with good URL
        // 2. Tap Connect Transfer Button to launch Connect Transfer flow
        // 3. Assert Exit button exists
        // 4. Tap Cross button
        // 5. Assert Yes button exists
        // 6. Tap Yes button
        
        let uiTextField: XCUIElement = app.textFields[AccessiblityIdentifer.UrlTextField.rawValue]//.typeText(badExpiredUrl)
        uiTextField.typeText(dynamicGeneratedUrl!)
        app.buttons[AccessiblityIdentifer.ConnectButton.rawValue].tap()
        
        XCTAssert(app.buttons["close"].waitForExistence(timeout: 5))
        app.buttons["close"].tap()
        
        XCTAssert(app.buttons["Yes, exit"].waitForExistence(timeout: 5))
        app.buttons["Yes, exit"].tap()
        
        sleep(2)
    }
    
    func test04SafariViewController() throws {
        /// Need to be discussed
        
        
        XCTAssertNotNil(dynamicGeneratedUrl)
        
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        // Steps:
        // 1. Fill in textfield with good URL
        // 2. Tap Connect Transfer Button to launch Connect Transfer flow
        // 3. Assert Exit button exists
        // 4. Tap on Privacy policy text
        // 5. Assert Done button exists
        // 6. Tap Done button
        
        app.textFields[AccessiblityIdentifer.UrlTextField.rawValue].typeText(dynamicGeneratedUrl!)
        app.buttons[AccessiblityIdentifer.ConnectButton.rawValue].tap()
        
        print("******************************************")
        print("App buttons")
        print(app.buttons)

        print("******************************************")
        app.buttons["By pressing Next, you agree to Finicity’s Terms of Use and Privacy Notice "].tap()
        
        XCTAssert(app.buttons["Done"].waitForExistence(timeout: 15))
        let doneButton = app.buttons["Done"]
        doneButton.tap()
        
        sleep(5)
        
    }
    
    func test05LaunchDepositSwitchFlow() throws {
        XCTAssertNotNil(dynamicGeneratedUrl)
        
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        // Steps:
        // 1. Fill in textfield with Good URL (Dynamic Generated URL)
        // 2. Tap Connect Transfer Button to launch Connect Transfer
        // 3. Wait for validation of the URL
        // 4. Connect Transfer Screen will appear
        // 5. Tap on Next Button
        // 6. Deposit Switch flow will appear
        // 7. Check if Deposit switch flow got initialized by checking the "find your payroll provider" exists
        
        
        let uiTextField: XCUIElement = app.textFields[AccessiblityIdentifer.UrlTextField.rawValue]
        uiTextField.typeText(dynamicGeneratedUrl!)
        app.buttons[AccessiblityIdentifer.ConnectButton.rawValue].tap()
        
        XCTAssert(app.buttons["Next"].waitForExistence(timeout: 5))
        app.buttons["Next"].tap()
        
        XCTAssert(app.staticTexts["find your payroll provider"].waitForExistence(timeout: 5))
        
        sleep(2)
    }
    
    //MARK: - Deposit Switch Flow TestCases
    func test06SelectPayrollProvider() throws {
        
        XCTAssertNotNil(dynamicGeneratedUrl)
        
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        // Steps:
        // 1. Fill in textfield with Good URL (Dynamic Generated URL)
        // 2. Tap Connect Transfer Button to launch Connect Transfer
        // 3. Wait for validation of the URL
        // 4. Connect Transfer Screen will appear
        // 5. Tap on Next Button
        // 6. Deposit Switch flow will appear
        // 7. Click on the Payroll Provider "Lowe's"
        
        
        let uiTextField: XCUIElement = app.textFields[AccessiblityIdentifer.UrlTextField.rawValue]
        uiTextField.typeText(dynamicGeneratedUrl!)
        app.buttons[AccessiblityIdentifer.ConnectButton.rawValue].tap()
        
        XCTAssert(app.buttons["Next"].waitForExistence(timeout: 5))
        app.buttons["Next"].tap()
        
        XCTAssert(app.webViews.buttons["Lowe's"].waitForExistence(timeout: 15))
        
        app.buttons["Lowe's"].tap()
        
        sleep(2)
    }
    
    func test07SubmitCredentials() throws {
        
        XCTAssertNotNil(dynamicGeneratedUrl)
        
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        // Steps:
        // 1. Fill in textfield with Good URL (Dynamic Generated URL)
        // 2. Tap Connect Transfer Button to launch Connect Transfer
        // 3. Wait for validation of the URL
        // 4. Connect Transfer Screen will appear
        // 5. Tap on Next Button
        // 6. Deposit Switch flow will appear
        // 7. Click on the Payroll Provider "Lowe's"
        
        
        let uiTextField: XCUIElement = app.textFields[AccessiblityIdentifer.UrlTextField.rawValue]
        uiTextField.typeText(dynamicGeneratedUrl!)
        app.buttons[AccessiblityIdentifer.ConnectButton.rawValue].tap()
        
        XCTAssert(app.buttons["Next"].waitForExistence(timeout: 5))
        app.buttons["Next"].tap()
        
        XCTAssert(app.webViews.webViews.webViews.buttons["Lowe's"].waitForExistence(timeout: 15))
        
        app.webViews.webViews.webViews.buttons["Lowe's"].tap()
        
        sleep(15)
        
//        XCTAssert(app.webViews.buttons["Submit"].waitForExistence(timeout: 15))
        
        sleep(2)
    }
    
    
//        sleep(2)
        
//        let webViewsQuery = app.webViews.webViews.webViews
//        XCTAssert(webViewsQuery.buttons["Next"].waitForExistence(timeout: 15))
//        webViewsQuery.buttons["Next"].tap()
//        XCTAssert(webViewsQuery.textFields["Search for your bank"].waitForExistence(timeout: 10))
//        webViewsQuery.textFields["Search for your bank"].tap()
//        webViewsQuery.textFields["Search for your bank"].typeText("finbank")
//        sleep(5)
//        XCTAssert(webViewsQuery.otherElements.staticTexts["FinBank"].waitForExistence(timeout: 15))
//        webViewsQuery.otherElements.staticTexts["FinBank"].tap()
//        
//        sleep(2)
//        
//        XCTAssert(webViewsQuery.buttons["Next"].waitForExistence(timeout: 15))
//        webViewsQuery.buttons["Next"].tap()
//        XCTAssert(webViewsQuery.staticTexts["Banking Userid"].waitForExistence(timeout: 15))
//        XCTAssert(webViewsQuery.staticTexts["Banking Password"].waitForExistence(timeout: 15))
//        webViewsQuery.textFields["Banking Userid"].tap()
//        webViewsQuery.textFields["Banking Userid"].typeText("demo")
//        webViewsQuery.secureTextFields["Banking Password"].tap()
//        webViewsQuery.secureTextFields["Banking Password"].typeText("go")
//        sleep(2)
//        app.keyboards.buttons["return"].tap()
//        sleep(2)
//        webViewsQuery.buttons["Submit"].tap()

//        sleep(5)
//        
//        app.switches.element(boundBy: 1).tap()
//        
//        webViewsQuery.staticTexts["Line of Credit"].swipeUp()
//        XCTAssert(webViewsQuery.buttons["Save"].waitForExistence(timeout: 5))
//        webViewsQuery.buttons["Save"].tap()
//        XCTAssert(webViewsQuery.buttons["Submit"].waitForExistence(timeout: 5))
//        webViewsQuery.buttons["Submit"].tap()
        
//        sleep(2)
//    }
    
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
