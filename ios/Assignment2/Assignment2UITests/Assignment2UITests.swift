//
//  Assignment2UITests.swift
//  Assignment2UITests
//
//  Created by YuTing Lai on 2/1/2022.
//

import XCTest

class Assignment2UITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testRegisterAndLogin(){
        let ac = arc4random();
        let pwd = arc4random();
        
        let app = XCUIApplication();
        
        app.tabBars["Tab Bar"].buttons["Account"].tap()

        app/*@START_MENU_TOKEN@*/.staticTexts["Register"]/*[[".buttons[\"Register\"].staticTexts[\"Register\"]",".staticTexts[\"Register\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        app.textFields["account ( username )"].tap()
        app.textFields["account ( username )"].typeText("\(ac)")

        app.textFields["email"].tap()
        app.textFields["email"].typeText("\(ac) email")

        app.textFields["phone"].tap()
        app.textFields["phone"].typeText("\(ac) phone")

        app.secureTextFields["password"].tap()
        app.secureTextFields["password"].typeText("\(pwd)")
        
        app.secureTextFields["confirm password"].tap()
        app.secureTextFields["confirm password"].typeText("\(pwd)")
        
        app.buttons["Register"].staticTexts["Register"].tap()
        
        app.alerts["Success"].scrollViews.otherElements.buttons["OK"].tap()

        app.textFields["Account ( Username )"].tap()
        app.textFields["Account ( Username )"].typeText("\(ac)")

        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("\(pwd)")
        
        app/*@START_MENU_TOKEN@*/.staticTexts["Login"]/*[[".buttons[\"Login\"].staticTexts[\"Login\"]",".staticTexts[\"Login\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
    }
    
    

}
