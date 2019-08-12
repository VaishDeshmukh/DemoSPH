//
//  DemoSPHUITests.swift
//  DemoSPHUITests
//
//  Created by Vaishu on 9/8/19.
//  Copyright © 2019 Vaishu. All rights reserved.
//

import XCTest

class DemoSPHUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testNavigationOnTap() {
        XCUIApplication().tables/*@START_MENU_TOKEN@*/.staticTexts["2011"]/*[[".cells.staticTexts[\"2011\"]",".staticTexts[\"2011\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        XCTAssert(app.navigationBars["2011 data consumption"].exists)
    }
}
