//
//  BitcoinOverviewUITests.swift
//  BitcoinOverviewUITests
//
//  Created by Chris Xu on 2019/4/13.
//  Copyright © 2019 CXCreation. All rights reserved.
//

import XCTest

class BitcoinOverviewUITests: XCTestCase {

    let application = XCUIApplication()
    
    override func setUp() {
        continueAfterFailure = false
        
        application.launchEnvironment = ["isUITest": "true"]
        application.launch()
    }

    override func tearDown() {
        
    }

    func testExample() {
        
    }

}
