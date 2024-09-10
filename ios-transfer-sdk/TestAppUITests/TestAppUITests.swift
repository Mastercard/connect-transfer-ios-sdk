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
//        let awesomeToken = ProcessInfo.processInfo.environment["FINICITY_APP_KEY_SAVED"]!
//        print(awesomeToken)
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
        // 4. Will go to failure screen
        // 5. Tap on Exit button
        
        let uiTextField: XCUIElement = app.textFields[AccessiblityIdentifer.UrlTextField.rawValue]
        uiTextField.typeText(badExpiredUrl)
        app.buttons[AccessiblityIdentifer.ConnectButton.rawValue].tap()
        
        sleep(3)
        
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
        
        sleep(5)
        
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
        
        sleep(5)
        
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
        // 3. Tap on Privacy policy text
        // 4. Assert Done button exists
        // 5. Tap Done button
        
        app.textFields[AccessiblityIdentifer.UrlTextField.rawValue].typeText(dynamicGeneratedUrl!)
        app.buttons[AccessiblityIdentifer.ConnectButton.rawValue].tap()
        
        sleep(5)
        
        app.buttons["By pressing Next, you agree to Finicity’s Terms of Use and Privacy Notice "].tap()
        
        sleep(3)
        
        XCTAssert(app.buttons["Done"].waitForExistence(timeout: 15))
        let doneButton = app.buttons["Done"]
        doneButton.tap()
        
        sleep(3)
        
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
        
        sleep(5)
        
        XCTAssert(app.buttons["Next"].waitForExistence(timeout: 5))
        app.buttons["Next"].tap()
        
        XCTAssert(app.staticTexts["find your payroll provider"].waitForExistence(timeout: 5))
        
        sleep(3)
    }
    
    //MARK: - Deposit Switch Flow TestCases
    func test06SearchPayrollProvider() throws {
        
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
        // 7. Click on the search field
        // 8. Search for "Workday"
        
        let uiTextField: XCUIElement = app.textFields[AccessiblityIdentifer.UrlTextField.rawValue]
        uiTextField.typeText(dynamicGeneratedUrl!)
        app.buttons[AccessiblityIdentifer.ConnectButton.rawValue].tap()
        
        sleep(5)
        
        XCTAssert(app.buttons["Next"].waitForExistence(timeout: 5))
        app.buttons["Next"].tap()
        
        sleep(10)
        
        let appWebView = app.webViews
        
        XCTAssert(appWebView.searchFields["find your payroll provider"].waitForExistence(timeout: 15))
        appWebView.searchFields["find your payroll provider"].tap()
        
        sleep(3)
        
        appWebView.searchFields["find your payroll provider"].typeText("Workday")
                
        sleep(3)
    }
    
    func test07SelectPayrollProvider() throws {
        
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
        // 7. Click on the search field
        // 8. Search for "Workday"
        // 9. Click on the Payroll Provider "Workday"
        // 10. Click on company "Home Depot"
        
        let uiTextField: XCUIElement = app.textFields[AccessiblityIdentifer.UrlTextField.rawValue]
        uiTextField.typeText(dynamicGeneratedUrl!)
        app.buttons[AccessiblityIdentifer.ConnectButton.rawValue].tap()
        
        XCTAssert(app.buttons["Next"].waitForExistence(timeout: 5))
        app.buttons["Next"].tap()
        
        sleep(10)
        
        let appWebView = app.webViews
        
        XCTAssert(appWebView.searchFields["find your payroll provider"].waitForExistence(timeout: 15))
        appWebView.searchFields["find your payroll provider"].tap()
        
        sleep(3)
        
        appWebView.searchFields["find your payroll provider"].typeText("Workday")
                
        sleep(3)
        
        XCTAssert(appWebView.buttons["Workday"].waitForExistence(timeout: 15))
        appWebView.buttons["Workday"].tap()
        
        sleep(3)
        
        XCTAssert(appWebView.buttons["Home Depot"].waitForExistence(timeout: 15))
        appWebView.buttons["Home Depot"].tap()
        
        sleep(3)
        
    }
    
    func test08EnterGoodCredentials() throws {
        
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
        // 7. Click on the search field
        // 8. Search for "Workday"
        // 9. Click on the Payroll Provider "Workday"
        // 10. Click on company "Home Depot"
        // 11. Enter the username "test-good" and Click continue
        // 12. Enter the password "qwerty" and Click continue
        
        let uiTextField: XCUIElement = app.textFields[AccessiblityIdentifer.UrlTextField.rawValue]
        uiTextField.typeText(dynamicGeneratedUrl!)
        app.buttons[AccessiblityIdentifer.ConnectButton.rawValue].tap()
        
        XCTAssert(app.buttons["Next"].waitForExistence(timeout: 5))
        app.buttons["Next"].tap()
        
        sleep(10)
        
        let appWebView = app.webViews
        
        XCTAssert(appWebView.searchFields["find your payroll provider"].waitForExistence(timeout: 15))
        appWebView.searchFields["find your payroll provider"].tap()
        
        sleep(3)
        
        appWebView.searchFields["find your payroll provider"].typeText("Workday")
                
        sleep(3)
        XCTAssert(appWebView.buttons["Workday"].waitForExistence(timeout: 15))
        appWebView.buttons["Workday"].tap()
        
        sleep(3)
        XCTAssert(appWebView.buttons["Home Depot"].waitForExistence(timeout: 15))
        appWebView.buttons["Home Depot"].tap()
        
        sleep(3)
        XCTAssert(appWebView.textFields["Username"].waitForExistence(timeout: 15))
        appWebView.textFields["Username"].typeText("test-good")
        
        XCTAssert(appWebView.buttons["Continue"].exists)
        appWebView.buttons["Continue"].tap()
        
        sleep(3)
        XCTAssert(appWebView.secureTextFields["Password"].waitForExistence(timeout: 15))
        appWebView.secureTextFields["Password"].typeText("qwerty")
        
        XCTAssert(appWebView.buttons["Continue"].exists)
        appWebView.buttons["Continue"].tap()
        
        sleep(3)
    }
    
    func test09ChangeDepositAllocation() throws {
        
        XCTAssertNotNil(dynamicGeneratedUrl)
        
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        
        // Steps
        // 1. Enter Good Credentils
        // 2. Click on "Change deposit amount"
        // 3. Click on "Specific amount"
        // 4. Click on "111" to enter the amount
        // 5. Click on Continue to confirm
        
        try self.test08EnterGoodCredentials()
        
        let appWebView = app.webViews
        
        XCTAssert(appWebView.buttons["Change deposit amount"].waitForExistence(timeout: 15))
        appWebView.buttons["Change deposit amount"].tap()
        
        XCTAssert(appWebView.otherElements["Specific amount"].waitForExistence(timeout: 5))
        appWebView.otherElements["Specific amount"].tap()
        
        XCTAssert(appWebView.buttons["1"].waitForExistence(timeout: 5))
        appWebView.buttons["1"].tap()
        appWebView.buttons["1"].tap()
        appWebView.buttons["1"].tap()
        
        XCTAssert(appWebView.buttons["Continue"].waitForExistence(timeout: 5))
        appWebView.buttons["Continue"].tap()
        
        sleep(3)
        
    }
    
    func test10SubmitGoodCredentials() throws {
        
        XCTAssertNotNil(dynamicGeneratedUrl)
        
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        
        // Steps
        // 1. Enter Good Credentils
        // 2. Change deposit allocation
        // 3. Submit the credentials by tapping on Confirm
        
        try self.test09ChangeDepositAllocation()
        
        let appWebView = app.webViews
        
        XCTAssert(appWebView.buttons["Confirm"].waitForExistence(timeout: 5))
        appWebView.buttons["Confirm"].tap()
        
        sleep(3)
    }
    
    func test11ReturnToPartnerSuccessCase() throws {
        XCTAssertNotNil(dynamicGeneratedUrl)
        
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        
        // Steps
        // 1. Enter Good Credentils
        // 2. Change deposit allocation
        // 3. Submit the credentials by tapping on Confirm
        // 4. Tap on return to partner
        
        try self.test10SubmitGoodCredentials()
        
        sleep(20)
        
        let appWebView = app.webViews
        
        let predicate = NSPredicate(format: "label BEGINSWITH[cd] 'Return to'")
        XCTAssert(appWebView.buttons.element(matching: predicate).waitForExistence(timeout: 5))
        
        appWebView.buttons.element(matching: predicate).tap()
        
        sleep(3)
        
    }
    
    func test12EnterBadCredentials() throws {
        
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
        // 7. Click on the search field
        // 8. Search for "Workday"
        // 9. Click on the Payroll Provider "Workday"
        // 10. Click on company "Home Depot"
        // 11. Enter the username "test-system-unavailable" and Click continue
        // 12. Enter the password "qwerty" and Click continue
        
        let uiTextField: XCUIElement = app.textFields[AccessiblityIdentifer.UrlTextField.rawValue]
        uiTextField.typeText(dynamicGeneratedUrl!)
        app.buttons[AccessiblityIdentifer.ConnectButton.rawValue].tap()
        
        XCTAssert(app.buttons["Next"].waitForExistence(timeout: 5))
        app.buttons["Next"].tap()
        
        sleep(10)
        
        let appWebView = app.webViews
        
        XCTAssert(appWebView.searchFields["find your payroll provider"].waitForExistence(timeout: 15))
        appWebView.searchFields["find your payroll provider"].tap()
        
        sleep(3)
        
        appWebView.searchFields["find your payroll provider"].typeText("Workday")
                
        sleep(3)
        XCTAssert(appWebView.buttons["Workday"].waitForExistence(timeout: 15))
        appWebView.buttons["Workday"].tap()
        
        sleep(3)
        XCTAssert(appWebView.buttons["Home Depot"].waitForExistence(timeout: 15))
        appWebView.buttons["Home Depot"].tap()
        
        sleep(3)
        XCTAssert(appWebView.textFields["Username"].waitForExistence(timeout: 15))
        appWebView.textFields["Username"].typeText("test-system-unavailable")
        
        XCTAssert(appWebView.buttons["Continue"].exists)
        appWebView.buttons["Continue"].tap()
        
        sleep(3)
        XCTAssert(appWebView.secureTextFields["Password"].waitForExistence(timeout: 15))
        appWebView.secureTextFields["Password"].typeText("qwerty")
        
        XCTAssert(appWebView.buttons["Continue"].exists)
        appWebView.buttons["Continue"].tap()
        
        sleep(3)
    }
    
    func test13SubmitBadCredentials() throws {
        
        XCTAssertNotNil(dynamicGeneratedUrl)
        
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        
        // Steps
        // 1. Enter Bad Credentils
        // 3. Submit the credentials by tapping on Confirm
        
        try self.test12EnterBadCredentials()
        
        let appWebView = app.webViews
        
        XCTAssert(appWebView.buttons["Confirm"].waitForExistence(timeout: 5))
        appWebView.buttons["Confirm"].tap()
        
        sleep(3)
    }
    
    func test14ReturnToPartnerFailureCase() throws {
        XCTAssertNotNil(dynamicGeneratedUrl)
        
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        
        // Steps
        // 1. Enter Bad Credentils
        // 2. Submit the credentials by tapping on Confirm
        // 3. Tap on Close
        // 4. Tap on return to partner
        
        try self.test13SubmitBadCredentials()
        
        sleep(10)
        
        let appWebView = app.webViews
        
        XCTAssert(appWebView.buttons["Close"].waitForExistence(timeout: 5))
        
        appWebView.buttons["Close"].tap()
        
        let predicate = NSPredicate(format: "label BEGINSWITH[cd] 'Return to'")
        XCTAssert(appWebView.buttons.element(matching: predicate).waitForExistence(timeout: 5))
        
        appWebView.buttons.element(matching: predicate).tap()
        
        sleep(3)
        
    }
    
    func test15CloseDepositSwitchFlow() throws {
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
        
        sleep(5)
        
        XCTAssert(app.buttons["Next"].waitForExistence(timeout: 5))
        app.buttons["Next"].tap()
        
        XCTAssert(app.staticTexts["find your payroll provider"].waitForExistence(timeout: 5))
        
        sleep(2)
        
        let appWebView = app.webViews
        
        XCTAssert(appWebView.buttons["Close"].waitForExistence(timeout: 5))
        
        appWebView.buttons["Close"].tap()
        
        let predicate = NSPredicate(format: "label BEGINSWITH[cd] 'Return to'")
        XCTAssert(appWebView.buttons.element(matching: predicate).waitForExistence(timeout: 5))
        
        appWebView.buttons.element(matching: predicate).tap()
        
        sleep(3)
    }
    
}
