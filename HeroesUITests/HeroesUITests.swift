//
//  HeroesUITests.swift
//  HeroesUITests
//
//  Created by Bernardo Vala Lourenço on 06/11/2023.
//

import XCTest

final class HeroesUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTableViewDisplayingImagesAndTexts() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launchArguments = ["UITestingEnabled"]
        app.launch()
        
//        let tableViewCells = app.tables.cells
//        
//        let label1 = tableViewCells.staticTexts.element(boundBy: 0).value
//        let label2 = tableViewCells.staticTexts.element(boundBy: 1).value
//        let label3 = tableViewCells.staticTexts.element(boundBy: 2).value
//
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        XCTAssertEqual(label1 as! String, "name 1")
//        XCTAssertEqual(label2 as! String, "name 2")
//        XCTAssertEqual(label3 as! String, "name 3")
    }
}
