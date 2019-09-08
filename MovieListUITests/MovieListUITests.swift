//
//  MovieListUITests.swift
//  MovieListUITests
//
//  Created by Swati Wadhera on 03/09/19.
//  Copyright © 2019 Swati Wadhera. All rights reserved.
//

import XCTest

class MovieListUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUI() {
        
        let app = XCUIApplication()
        let tablesQuery = app.tables
        
        let cell = tablesQuery.cells.element(boundBy: 0)
        _ = cell.waitForExistence(timeout: 3)
        
        if tablesQuery.cells.count > 0 {
            cell.tap()
            _ = app.staticTexts["movietitle"].waitForExistence(timeout: 3)
            XCTAssertTrue(app.staticTexts["movietitle"].exists)
            XCTAssertTrue(app.staticTexts["runningtime"].exists)
            XCTAssertTrue(app.staticTexts["releasedate"].exists)
            XCTAssertTrue(app.staticTexts["language"].exists)
            XCTAssertTrue(app.staticTexts["genre"].exists)
            XCTAssertTrue(app.staticTexts["rating"].exists)
            XCTAssertTrue(app.staticTexts["synopsis"].exists)
            XCTAssertTrue(app.staticTexts["cast"].exists)
            
        }
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

}
