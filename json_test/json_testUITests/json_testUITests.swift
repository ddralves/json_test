//
//  json_testUITests.swift
//  json_testUITests
//
//  Created by Dino Alves on 2017/07/10.
//  Copyright © 2017 Dino Alves. All rights reserved.
//

import XCTest

class json_testUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        let app = XCUIApplication()
        
        setupSnapshot(app)
        
        let index = app.launchArguments.index(of: "-hello")!
        let hello = app.launchArguments[index + 1]
        
        print("Argument value is -> \(hello)")
        
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testExample() {
        
        let app = XCUIApplication()
        snapshot("Test")
        app.buttons["Search for e-mail"].tap()
        app.alerts["Something is wrong!"].buttons["Try Again"].tap()
        app.buttons["Display User's Names"].tap()
        app.alerts["Fetched Users"].buttons["OK"].tap()
        app.buttons["Get Samantha's E-mail"].tap()
        snapshot("Test1")
        app.alerts["E-mail for Samantha found!"].buttons["OK"].tap()
        
    }
    
}
