//
//  DemoSPHTests.swift
//  DemoSPHTests
//
//  Created by Vaishu on 9/8/19.
//  Copyright © 2019 Vaishu. All rights reserved.
//

import XCTest
@testable import DemoSPH

class DemoSPHTests: XCTestCase {
    var sut : URLSession!
    
    override func setUp() {
        super.setUp()
        sut = URLSession(configuration: .default)
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // Asynchronous test: success fast, failure slow
    func testValidCallToGetsHTTPStatusCode200() {
        // given
        let url = URL(string: "https://data.gov.sg/api/action/datastore_search?&limit=100&resource_id=a807b7ab-6cad-4aa6-87d0-e283a7353a0f")
        // 1
        let promise = expectation(description: "Status code: 200")
        
        // when
        let dataTask = sut.dataTask(with: url!) { data, response, error in
            // then
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    // 2
                    promise.fulfill()
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        dataTask.resume()
        // 3
        wait(for: [promise], timeout: 5)
    }
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
