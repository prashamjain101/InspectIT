//
//  LoginViewUITests.swift
//  InspectITUITests
//
//  Created by Prasham Jain on 27/06/24.
//

import XCTest

class LoginViewUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    func testLoginViewElements() throws {
        // Check if main elements are present
        XCTAssertTrue(app.images["person.circle.fill"].exists)
        XCTAssertTrue(app.staticTexts["InspectIT"].exists)
        XCTAssertTrue(app.staticTexts["Login to continue using the app"].exists)
        
        XCTAssertTrue(app.textFields["Enter your email"].exists)
        XCTAssertTrue(app.secureTextFields["Enter password"].exists)
        XCTAssertTrue(app.buttons["Forgot Password?"].exists)
        XCTAssertTrue(app.buttons["Login"].exists)
        
        XCTAssertTrue(app.staticTexts["Or Login with"].exists)
        XCTAssertTrue(app.buttons["f.circle.fill"].exists)
        XCTAssertTrue(app.buttons["g.circle.fill"].exists)
        XCTAssertTrue(app.buttons["applelogo"].exists)
        
        XCTAssertTrue(app.staticTexts["Don't have an account?"].exists)
        XCTAssertTrue(app.buttons["Register"].exists)
    }

    func testLoginFlow() throws {
        let emailTextField = app.textFields["Enter your email"]
        let passwordSecureTextField = app.secureTextFields["Enter password"]
        let loginButton = app.buttons["Login"]

        // Enter email and password
        emailTextField.tap()
        emailTextField.typeText("test@example.com")
        
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("password123")

        // Tap login button
        loginButton.tap()

    }

    func testSocialLoginAlerts() throws {
        // Test Facebook login alert
        app.buttons["f.circle.fill"].tap()
        XCTAssertTrue(app.alerts["Error"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.alerts["Error"].staticTexts["This Social login is not yet implemented."].exists)
        app.alerts["Error"].buttons["Ok"].tap()

        // Test Google login alert
        app.buttons["g.circle.fill"].tap()
        XCTAssertTrue(app.alerts["Error"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.alerts["Error"].staticTexts["This Social login is not yet implemented."].exists)
        app.alerts["Error"].buttons["Ok"].tap()

        // Test Apple login alert
        app.buttons["applelogo"].tap()
        XCTAssertTrue(app.alerts["Error"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.alerts["Error"].staticTexts["This Social login is not yet implemented."].exists)
        app.alerts["Error"].buttons["Ok"].tap()
    }

    func testNavigationToSignUp() throws {
        app.buttons["Register"].tap()
    }
}
